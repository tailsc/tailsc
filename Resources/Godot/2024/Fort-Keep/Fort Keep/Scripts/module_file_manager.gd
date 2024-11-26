extends RefCounted
# Module File Manager
#--------------------------------
# Handle file operations.
#--------------------------------

const M_C = preload("res://Scripts/module_constants.gd")
const M_D_C = preload("res://Scripts/module_data_compiler.gd")

static func Print_File(filepath:String) -> void:
	var text:String = FileAccess.open(filepath,FileAccess.READ).get_as_text()
	print(text)

static func Print_All_Files_In_Folder(filepath_folder:String) -> void:
	for file in DirAccess.get_files_at(filepath_folder):
		print(file)
		Print_File(filepath_folder + file)
		
static func Save_Text_File(filepath_and_name:String,text:String) -> void:
	var file:FileAccess = FileAccess.open(filepath_and_name,FileAccess.WRITE)
	file.store_string(text)
	file.close()
	
static func Load_Text_File(filepath_and_name:String) -> String:
	var text:String = FileAccess.open(filepath_and_name,FileAccess.READ).get_as_text()
	return text
	
static func File_Exists(path:String) -> bool:
	if FileAccess.file_exists(path):return true
	printerr("MODULE_FILE_MANAGER: File dose not exist! path: ", path)
	return false
	
static func Encode_Data_File(filepath:String) -> void:
	if !File_Exists(filepath):return
	
	var load_file_data:String = FileAccess.open(filepath,FileAccess.READ).get_as_text()
	var save_file_path:String = filepath.replace(M_C.FORMAT_CSVDATA,M_C.FORMAT_DATA)
	
	var encoded_text:String = M_D_C.encode_data_to_string(load_file_data)
	Save_Text_File(save_file_path,encoded_text)

