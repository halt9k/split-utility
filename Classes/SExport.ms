struct SExport(
	ostream = undefined, 
	tabs = "",


	fn OutputVerts tmesh ostream =(
		cn = (geometry.max + geometry.min) / 2
		print ("Node center:" + (cn as string))
		
		if tmesh.numVerts > 0 then(
			--print (format("% % % \n") (node.Center.x)(node.Center.y)(node.Center.z))
			
			format (tabs+"Mesh vertices:\n") to:ostream
			for i = 1 to tmesh.numVerts do(
				vt = GetVert tmesh i
				format (tabs+"\t% % %\n") (vt.x-cn.x) (vt.y-cn.y) (vt.z-cn.z) to:ostream     
			)
			format (tabs+"end vertices\n") to:ostream
		)		
	),

	
	fn OutputFaceIDs tmesh ostream =(
		if tmesh.numFaces > 0 then(
			format (tabs+"Mesh faces:\n") to:ostream
			for i = 1 to tmesh.numFaces do(
				fs = GetFace tmesh i
				format (tabs+"\t% % %\n") (fs.x as Integer) (fs.y as integer) (fs.z as Integer) to:ostream
			)
			format (tabs+"end faces\n") to:ostream
		)	
	),


	fn OutputFaceNormals tmesh ostream =(
		if tmesh.numFaces > 0 then(
			format (tabs+"Faset normals:\n") to:ostream
			for i = 1 to tmesh.numFaces do(
				nm = GetFaceNormal tmesh i
				format (tabs+"\t% % %\n") nm.x nm.y nm.z to:ostream
			)
			format (tabs+"end faset normals\n") to:ostream
		)
	),
	
	
	/*
	fn OutputFasetNormals tmesh ostream =(
		if node.numFaces > 0 then(
			format (tabs+"Normals:\n") to:ostream
			for i = 1 to node.numFaces do(
				vertts=meshop.GetFaceRNormals tmesh i
				format (tabs+"\t% % %\n") vertts[1].x vertts[1].y vertts[1].z to:ostream
				format (tabs+"\t% % %\n") vertts[2].x vertts[2].y vertts[2].z to:ostream
				format (tabs+"\t% % %\n") vertts[3].x vertts[3].y vertts[3].z to:ostream  
			)
			format (tabs+"end normals\n") to:ostream
		)
	),
	*/


	fn OutputSmoothingNormals node tmesh ostream =(
		if tmesh.numVerts > 0 then(
			format (tabs+"Smooth normals:\n") to:ostream
			Normals.ExportRealNormals node ostream tabs
			format (tabs+"end smooth normals\n") to:ostream
		)		
	),


	fn ExportMesh node =(
		tmesh = snapshotAsMesh node
		
		format (tabs + "TriMesh()\n") to:ostream
		format (tabs + "numverts numfaces\n") to:ostream
		format (tabs + "   %        %\n") tmesh.numverts tmesh.numfaces to:ostream

		OutputVerts tmesh ostream
		OutputFaceIDs tmesh ostream
		
		-- unused, but to support format
		OutputFaceNormals tmesh ostream
		-- Possibly correct and match below
		-- OutputFasetNormals tmesh ostream
		
		OutputSmoothingNormals node tmesh ostream
		
		format (tabs+"end mesh\n") to:ostream
	),


	fn CheckIfGeneric node =(
		return not (ClassOf node == Targetobject and node.isTarget)
	),


	fn ExportNode node =(
		format "New object\n" to:ostream
		
		--print("SuperClass : ")
		--print(SuperClassOf node)
		--print("Calss: ")
		--print(ClassOf node)		

		if Nodes.IsEditablePoly(node) then(
			--split all hard edges, which have multiple normals to avoid obj multiple normal conflict
			node_copy = copy node				
			Normals.FixMultinormalVertices node_copy
			ExportMesh node_copy
			delete node_copy
		)else if CheckIfGeneric(node) then(
			messageBox "Not editable poly or modifers on top of poly. Not exported"
			return false
		)else(
			messageBox "Natin selected"
			return false
		)

		return true
	),


	fn RecursiveExportNode node =(
		if not (ExportNode node) then
			return false

		-- Recurse children before writing this node
		for child in node.children do
			RecursiveExportNode child
			
		format "\n\n" to:ostream
	),


	fn FormatName nm=(
		res = nm
		n_id = Nodes.GetID nm
		if (n_id > -1) and (n_id < 10) then
			res = "0" + n_id as string
		else
			res = n_id as string
		return res			
	),


	fn ExportNodes =(
		valids = Nodes.GetValidNodes(True)
		
		fld = IO.GetSaveDir()
		if fld == undefined then 
			return undefined
		
		bCheckFiles = (valids.Count > 10)
		filesNew = #()
		filesPrev = #()
		
		if bCheckFiles then
			fld + "\\*" + IO.file_ext
			
		for node in valids do(
			fname = FormatName(node.name)
			windows.processPostedMessages()
			
			print "Exporting " + fname
			if bCheckFiles then
				append filesNew fname
			
			ostream = IO.GetSaveStream fname fld
			if ostream != undefined then(
				RecursiveExportNode node
				format "end of file" to:ostream 
				Close ostream
			)
		)
		
		if bCheckFiles and (filesPrev.Count != filesNew.Count) then
			print "WARNING: amount of exported files not equal to amount of previous \n"
		
	)


	/* leftovers from past, unused
	fn ExportTarget obj =(
		format (tabs+"myobj.target = Targetobject()\n") to:ostream
		format (tabs+"myobj.target.name = \"%\"\n") obj.target.name to:ostream
		format (tabs+"myobj.target.transform = %\n") obj.target.transform to:ostream
		format (tabs+"myobj.target.position += createPos\n") to:ostream
	),


	fn ExportGeneric obj =(
		format (tabs+"%\n") (ClassOf obj) to:ostream

		for prop in GetPropNames obj do(
			propname = prop as String
			propval  = GetProperty obj prop

			if (ClassOf obj) == Hedra and (prop == #vertices) then 
				continue

			if propval != undefined then
				(tabs+"\t% %\n") propname propval to:ostream
		)

		if obj.target != undefined then
			ExportTarget obj

		format (tabs+"end %\n") (ClassOf obj) to:ostream
	)
	*/
)