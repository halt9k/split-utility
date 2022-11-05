struct SIO(
	work_dir = "c:\Temp",
	file_ext = ".mf",
	file_mask = "*" + file_ext,

	
	fn GetSaveDir =(
		if not isDirectoryWriteable(work_dir) then(
			file_desc = "Meshes Files (" + file_mask + ")|" + file_mask
			file_desc = file_desc + "|All Files(*.*)|*.*|"
			sel_dir = getSaveFileName types: file_desc
			sel_pth = getFilenamePath sel_dir
			work_dir = trimRight sel_pth "\\"
		)
		
		if (work_dir == undefined) then
			print "Save dir missing or not writable"
		else if not isDirectoryWriteable(work_dir) then
			print ("Save dir not writable, ensure no spaces: " + work_dir)
			
		return work_dir
	),


	fn FileExists fname =(
		fls = getFiles(fname)
		return fls.count != 0
	),


	fn GetSaveStream nodename path =(
		-- auto mode pre-code
		fname = path + "\\" + nodename + file_ext
		
		if FileExists(fname) then
			deleteFile(fname)

		ostream = CreateFile(fname)
		if ostream == undefined then(
			messageBox "Couldn't open file for writing !"
			return undefined
		)

		return ostream
	)
)