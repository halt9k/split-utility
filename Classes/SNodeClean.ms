struct SNodeClean(


	fn TestClean =(
		_VuF = polyOp.getVertsUsingFace
		_FuV = polyOp.getFacesUsingVert
		_VuE = polyOp.getVertsUsingEdge
		_EuF = polyOp.getElementsUsingFace
		_V = polyOp.getVert

		sel_node = selection[1]
		
		if sel_node == undefined then(
			print "Selection reqiured"
			return undefined
		)
		
		
		threshold = 0.01

		elements = #()
		weld_verts = #{}
		open_verts = _VuE sel_node (polyOp.getOpenEdges sel_node)
		print open_verts

		for v in open_verts do(
			face = _FuV sel_node v
			element = _EuF sel_node face
			elementverts = (_VuF sel_node element) * open_verts

			element = for e in elementverts collect(
				deleteItem open_verts e
					#(e, _V sel_node e)
			)
			append elements element
		)

		for i = 1 to elements.count do(
			el_i = elements[i]
			
			for x = el_i.count to 1 by -1 do(
				if weld_verts[el_i[x][1]] then
					deleteItem el_i x
			)

			for v1 in el_i do(
				vpos = v1[2]
				for v = i+1 to elements.count do(
					for v2 in elements[v] where (distance vpos v2[2]) <= threshold do(
						append weld_verts v1[1]
						append weld_verts v2[1]
					)
				)
			)
		)

		-- visualize welded vertices
		polyOp.setVertSelection sel_node weld_verts
		
		sel_node.weldThreshold = threshold
		polyOp.weldVertsByThreshold sel_node weld_verts
	)
)