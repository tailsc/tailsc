extends Node

const M_C = preload("res://Scripts/module_constants.gd")
const M_D_C = preload("res://Scripts/module_data_compiler.gd")
const M_F_M = preload("res://Scripts/module_file_manager.gd")


var data:Dictionary = {
	"gamedata" : {}
}

func _ready() -> void:
	#M_F_M.Print_All_Files_In_Folder(M_C.PATH_FOLDER_DATA)
	M_D_C.compile_csvdata_files()
	M_D_C.build_data_dictionaries(data)
	#print(JSON.stringify(data,"\t"))
	print(data["gamedata"][0]["NAME"])

