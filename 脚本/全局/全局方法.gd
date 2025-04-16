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

func 从实例切换场景(场景实例: Node) -> void:#by 鱼雷
	# 先获取场景树, 从而获取当前场景, 进而把当前场景杀害.
	var 场景树 = get_tree()
	场景树.current_scene.queue_free()# 温柔且安全的逐渐肢解.
	
	# 将 新场景 加入进场景树.
	场景树.root.add_child(场景实例)
	
	# 重新赋值 当前场景, 否则下一次调用可能出错.
	场景树.current_scene = 场景实例
	print("切换到了新场景: "+场景树.current_scene.to_string())

func 覆写文件(路径 : String , 内容 : Variant , 覆写类型 : String = "json") -> void:
	var 父目录 = 路径.get_base_dir()
	if not DirAccess.dir_exists_absolute(父目录):
		DirAccess.make_dir_recursive_absolute(父目录)
	var 文件句柄 : FileAccess = FileAccess.open(路径 , FileAccess.WRITE)
	if 文件句柄 == null:
		print("覆写文件失败，无法创建文件？路径:" + 路径)
		print("错误:" + str(FileAccess.get_open_error()))
		return
	if 覆写类型 == "json":
		文件句柄.store_string(JSON.stringify(内容))
		文件句柄.close()#TODO 暂时不考虑其他类型
