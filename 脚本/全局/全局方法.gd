extends Node

func 读取文件(文件路径 : String , 类型 : String) -> Variant:
	var 文件句柄 : FileAccess
	文件句柄 = FileAccess.open(文件路径,FileAccess.READ)
	if not 文件句柄 :
		return "读取文件出错"
	var 读取缓存 = 文件句柄.get_as_text()
	文件句柄.close()
	if 类型 == "json":
		var json读取缓存 : JSON = JSON.new()
		var json读取检查
		json读取检查 = json读取缓存.parse(读取缓存)
		if json读取检查 != OK:
			print("json读取错误" , json读取缓存.get_error_message())
			return "读取错误"
		return json读取缓存.data
	return "占位空字符串"#TODO 暂时不需要
	
func 世界初始化() -> void:
	pass
