struct SNodes(
	fn IsEditablePoly node =(
		return (superClassOf node == GeometryClass) and (classOf node == Editable_Poly)		
	),


	fn GetID name =(
		res = 0
		parseRes = (dotNetClass "System.Int32").TryParse name &res
		if parseRes and (res > -1) and  (res < 300) then
			return res
		else
			return -1
	),


	fn GetValidNodes bFilterName =(
		if selection.count < 1 then(
			print "Nothing selected, working on all model"
			list = rootnode.children
		)else
			list = selection
			
		cleaned_list = #()
		for node in list do(
			if bFilterName and GetID(node.name) < 0 then(
				if not (node == selection[1]) then(
					print ("Node skipped for name:  " + node.name)
					continue
				)
			)
			
			if not IsEditablePoly(node) then(
				print ("Node skipped for non-editable poly: " + node.name)
				continue
			)
			
			cleaned_list += node
		)
					
		return cleaned_list
	)
)