struct SNodeJoin(
	str_name_all = "All",
	

	fn MapMaterialsToName node =(
		--cur_sel_face = getFaceSelection node.mesh
		cur_sel_face = node.faces
		--print (node.name + " faces: " + (cur_sel_face.count as string))
		
		mat_id = Nodes.getID(node.name)
		if (mat_id == undefined) or (mat_id < 0) then
			Err.Reg ("Undefined material ID for node: " + node.name)
		else
			print mat_id
		
		polyOp.setFaceMatID node cur_sel_face (mat_id + 100)
	),


	fn Map =(
		for node in Nodes.GetValidNodes(True) do
			MapMaterialsToName node
	),


	fn AttachNodes =(
		print "WARNING: If Material IDs get messed up, possible reason is
			using _Attach options_ dialog before script with options to modify material ID"

		node_first = undefined
		node_list = Nodes.GetValidNodes(True)
		
		if node_list.count > 0 then(
			node_first = node_list[1]
				
			if node_list.count > 1 then
				node_first.name = str_name_all
			else
				print ("Materials set for: " + node_first.name)
		) else
			return undefined
		
		for node in node_list do(
			if node == node_first then
				continue
		
			polyOp.Attach node_first node
		)
	),


	fn WeldNodes =(
		for node in rootnode.children do(
			if node.name == str_name_all then
				continue
			
			node.weldThreshold = 0.01
			polyOp.weldVertsByThreshold node node.verts			
		)
	),
	
	
	fn Join =(
		AttachNodes()
		WeldNodes()
	)	
)