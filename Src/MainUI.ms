/*
Script to support workchain with splitting edge-lack 3D model to multiple parts
	provides nessesary fix to unpreserved normals on seals during split and join
	and other model cleanup automatization (possibly inoptimal after Max 2012)
	
	Main usage scenario:
		Open included test model
		Add this script using Utility -> MAXScript -> Run Script (select it from Utility list)
		Optional: Do nessesary changes (currently material ID's are reserved for internal labels)
		Use 4:Split, 5:Export to store model back

	Experimental:
		Manually drag model parts into 3dsMax (which must be stored under names "1,2,3,4...")
		Apply buttons 1:Map, 2:Join to prepare new supported model

	Peek MAXScript listener during all operations for hints and erros

	Tested and works fine on Max 2012/2016
	v6.8
*/


fn ReloadDependencies =(	
	fileIn "Classes\SSplit.ms"
	fileIn "Classes\SNormals.ms"
	fileIn "Classes\SNodes.ms"
	fileIn "Classes\SNodeJoin.ms"
	fileIn "Classes\SIO.ms"
	fileIn "Classes\SExport.ms"
	fileIn "Classes\SErrors.ms"
	fileIn "Classes\SNodeClean.ms"
)


fn CreateNamespaces =(
	print "Reload - creating objects"
	::Err = ::SErrors()
	::Nodes = ::SNodes()
	::NodeJoin = ::SNodeJoin()
	::IO = ::SIO()
	::Export = ::SExport()
	::NodeClean = ::SNodeClean()
	::Split = ::SSplit()
	::Normals = ::SNormals()
)


utility SplitTool "Split Toolchain" (
	/* unused
	group "Options" (
		checkbox cb_exportAll "Export all"
	)
	group "Frames" (
		spinner sp_start "From:" range:[animationrange.start,animationrange.end,animationrange.start] type:#Integer
		spinner sp_end "To:" range:[animationrange.start,animationrange.end,animationrange.end] type:#Integer
		spinner sp_step "Step:" range:[animationrange.start + 1,animationrange.end,animationrange.start + 1] type:#Integer
	)
	button btn_fix__face_normals "1: Fix face normals orientation" width:160
	*/
	
	label L00 "Select* and use:"
	
	button btn_map "1: Map nodes" width:140
	button btn_join "2: Join" width:140
	
	label L03 "3: Other changes"
	button btn_clean "3A: Clean (opt, beta)" width:120
	
	button btn_map_split "4: Split" width:120
	button btn_export "5: Export nodes" width:120
		
	label L06 ""
	label L07 "Optimal chain reminder:"
	label L08 "Smooth ( 50 )"
	label L09 "Optimise ( keep materials, 0.6 )"
	label L10 "Weld can destroy shading (eyes)"
	label L11 ""
	label L12 "* no selection = parse all"


	fn RefreshRollout =(
		--Rebuids top UI to prevent buttons freeze on exception
		UtilityPanel.CloseUtility()
		CloseUtility(SplitTool)

		gc()
		clearListener()

		fileIn(getThisScriptFilename())
		OpenUtility(SplitTool)
	)


	fn WrapUICall call_fn =(
		RefreshRollout()
		ReloadDependencies()
		CreateNamespaces()
		Err.Clear()

		fn_name = call_fn as string
		print(fn_name + " started")
		undo fn_name on(
			call_fn()
		)
		print(fn_name + " finished")

		Err.Finalize()
	)


	on btn_join pressed do(
		WrapUICall ::NodeJoin.Join
		)


	on btn_export pressed do
		WrapUICall ::Export.ExportNodes


	on btn_map pressed do
		WrapUICall ::NodeJoin.Map


	on btn_map_split pressed do
		WrapUICall ::Split.SplitByMaterials


	on btn_clean pressed do
		WrapUICall ::NodeClean.TestClean


	/*
	on btn_fix__face_normals pressed do
		WrapUICall FixNormals

	on sp_start changed value do
		slidertime = sp_start.value
	*/
)


fn on_load =(
	ReloadDependencies()
	CreateNamespaces()
	
	print "SplitTool initialised."	
)
on_load()