struct SNormals(


	fn GetIndexedlNormals edit_Normals_modifer  =(
		-- output all indexed normals to listener
		ArrNormals = #()
		for i = 1 to edit_Normals_modifer.getNumNormals() do(
			n = edit_Normals_modifer.getNormal i
			append ArrNormals n
		)
		if ArrNormals.count < 1 then
			print "Normals not detected"
		--else
			--print ("Normals detected, count: " + ArrNormals.Count as string)

		return ArrNormals
	),


	fn GetVertexNormalIndex edit_Normals_modifer VertID =(
		-- bitArray specifying vertex i
		my_verts = #{VertID}
		-- empty bitArray to store the result
		my_normals = #{}
		
		edit_Normals_modifer.convertVertexSelection &my_verts &my_normals
		if (my_normals.numberSet > 1) then(
			Err.Reg("WARNING: more than 1 normal per vertex")
			Err.Reg("VertID: " + VertID as string)
			Err.Reg("My_Normals: " + my_normals as string)
		)

		NormID = -1
		for i = 1 to my_normals.count do
			if (my_normals[i] == True) then(
				NormID = i
				break
			)
		if (NormID == -1) then(
			Err.Reg( "Aborted, missing normal for vertex: " + (i as string))
			break
			)

		return NormID
	),


	fn ExportRealNormals node export_stream tabs =(
		if (getCommandPanelTaskMode() != #modify) do
			setCommandPanelTaskMode #modify

		-- create and apply Edit_Normals modifier in order to be able to access explicit normal data
		m = Edit_Normals()
		addModifier node m
		modPanel.setCurrentObject m

		ArrNormals = GetIndexedlNormals(m)

		for i = 1 to m.getNumVertices() do(
			id = GetVertexNormalIndex(m)(i)
			if (id == -1) then(
				nm = [0,0,0]
				Err.Reg("WARNING: Mesh contains isolated vertices: " + node.name + " id " + (i as string))
			)else
				nm = ArrNormals[id]

			format (tabs+"\t% % %\n") nm.x nm.y nm.z to:export_stream
			--format "Vertex % uses normals %\n" i my_normals
		)
		deleteModifier node m
	),


	fn FixMultinormalVertices node =(
		if (getCommandPanelTaskMode() != #modify) then
			setCommandPanelTaskMode #modify

		m = Edit_Normals()
		addModifier node m
		modPanel.setCurrentObject m

		badvertices = #()

		for VertID = 1 to m.getNumVertices() do(
			-- bitArray specifying vertex i
			my_verts = #{VertID}
			-- an empty bitArray to store the result
			my_normals = #{}
			
			m.ConvertVertexSelection &my_verts &my_normals
			if (my_normals.numberSet > 1) then
				append badvertices VertID
		)

		deleteModifier node m

		--node.selectedVerts = badvertices
		--print ("Node: " + node.name + "   Vertices to split: " + badvertices as string + " Total: " + node.vertices.count as string)

		polyOp.breakVerts node badvertices

		--node.ConvertSelection 1 2
		--polyOp.splitEdges node node.selectedEdges
	)


	--almost works (correct detection, but final flip works badly) 
	--fixed in obj converter instead, more propiate place to do this
	/*
	fn GetAverageFaceNormal node edit_Normals_modifer FaceID ArrNormals =(
		VertIDs = polyOp.getFaceVerts node FaceID
		nm = 0
		sz = VertIDs.count
		--print ("Vert count: " + (sz as string))
		for j = 1 to sz do(
			VertID = VertIDs[j]
			NormIndex = GetVertexNormalIndex(edit_Normals_modifer) (VertID)
			nm = nm + ArrNormals[NormIndex]
		)
		return (nm / sz)
	),


	fn FixNodeNormals node =(
		if (getCommandPanelTaskMode() != #modify) do
			setCommandPanelTaskMode #modify

		print ("Fixing normals for node: " + node.name)

		-- create and apply Edit_Normals modifier in order to be able to access explicit normal data
		m = Edit_Normals()
		addModifier node m
		modPanel.setCurrentObject m

		ArrNormals = GetIndexedlNormals(m)
		if (ArrNormals.Count == 0) then(
			print ("Aborted, normals undetected")
			deleteModifier node m
			return undefined
		)
		--print ("Normals count: " + (ArrNormals.Count as string))
		if node.faces.count < 1 then("ERROR: No faces found")
			--print ("Faces count: " + (node.faces.count as string))


		sel = #{}
		for i = 1 to node.faces.count do(
			NMFace = polyOp.getFaceNormal (node) (i)
			NMVerts = GetAverageFaceNormal (node) (m) (i) (ArrNormals)
			if (dot NMFace NMVerts) < 0 then
				sel[i] = True
		)
		deleteModifier node m

		polyOp.setFaceSelection node sel
		--look what this script detects actually
		max modify mode --switch to Modify panel
		subObjectLevel = 4 --go to Face level to see the selection
		polyOp.flipNormals node sel
		max modify mode

		print ("Total: " + node.faces.count as string + "   Inverted faces: " + (sel as string))
	),

	fn FixNormals =(
		for node in Nodes.GetValidNodes(False) do(
			windows.processPostedMessages()
			FixNodeNormals node
		)
	)
	*/
)