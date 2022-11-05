struct SErrors(
	bOpenListener = False,

	fn Reg txt =(
		print(txt)
		bOpenListener = True
	),

	fn Clear =(
		bOpenListener = False
		clearListener()	
	),

	fn Finalize =(
		if bOpenListener then(
			actionMan.executeAction 0 "40472"
			bOpenListener = False
		)
	)
)