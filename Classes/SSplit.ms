struct SSplit(
	material_id_threshold = 100,


	fn GetMaterialIDs obj =(
		id_arr = #()

		for i in 1 to 512 do(
			obj.selectByMaterial i
			the_faces = getFaceSelection obj
			if (the_faces as array).count != 0 then
				append id_arr i
		)
		return id_arr
	),


	fn SplitPoly poly material_ids =(
		select poly

		-- to keep normal, must use element detach under Edit_Normals
		mEN = Edit_Normals()
		mEN.displayLength = 0
		addModifier poly mEN
		modPanel.setCurrentObject mEN
		s_NumNorm = mEN.GetNumNormals()
		mEN.SetSelection #{1..s_NumNorm}
		mEN.MakeExplicit()

		modPanel.setCurrentObject poly
		
		-- start detaching
		for i in material_ids do(
			poly.selectByMaterial i

			the_faces = getFaceSelection poly
			the_name = (i - material_id_threshold) as string

			polyOp.detachFaces poly the_faces asnode:false name:the_name
		)
		modPanel.setCurrentObject mEN
		convertTo poly Editable_Poly

		-- start splitting
		for i in material_ids do(
			the_name = (i - material_id_threshold) as string

			the_zone = copy poly
			the_zone.name = the_name
			the_zone.selectByMaterial i

			the_faces = getFaceSelection the_zone

			polyOp.deleteFaces the_zone -the_faces
		)

		-- checking no other faces exist
		for i in material_ids do(
			poly.selectByMaterial i
			the_faces = getFaceSelection poly
			polyOp.deleteFaces poly the_faces
		)

		if poly.faces.count > 0 then
			print "WARNING: Unmarked vertices"
		else
			delete poly		
	),


	fn SplitObj obj =(
		material_ids = #()

		--if (obj.material == undefined) then

		try(
			convertToPoly obj
		)catch(
			print ("DetacByID: Error Occured on Object Conversion: " + obj as string)
			return false
		)

		obj_orig = obj
		poly = copy obj_orig
		material_ids = GetMaterialIDs poly

		for i in material_ids do(
			if i < material_id_threshold then(				
				print ("Wrong material ID: " + i as string)
				print ("Expected all ID above: " + material_id_threshold as string)
				return false
			)
		)

		SplitPoly poly material_ids

		delete obj_orig
		return true
	),


	fn SplitByMaterials =(
		the_sel = selection as array
		if the_sel.count == 0 then(
			print("Nothing selected")
			return undefined
		)
			
		max modify mode

		for obj in the_sel do(
			if (superclassof obj != GeometryClass) then(
				print ("Object skipped, not a geometry: " + obj as string)
				continue
			)
			
			if not (SplitObj obj) then
				return undefined
		)

		max select none
	)
)


/*
About half of this file is used from:
	Detach by Material ID
	Version: 2
	by Jefferson Lim
	Terabye Inc./ Shirogumi Inc.	
	
	- works on a selection of objects
	- Options to name detached objects
	- material propagation
	- this will assign a corresponding material by id to the detached object

	[usage]
	1. select any number of objects
	2. set the desired paramteters

	[Internal Operations]
	Procedure:
	- object[s] is/are copied
	- then collapsed to an editable poly
	- faces are finally detached by material ID
*/