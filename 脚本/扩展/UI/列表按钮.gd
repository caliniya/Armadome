class_name 列表按钮
extends Button

var 自身参数 : int

func _init(按钮参数 : int , 宽度 : float = 250.0 , 高度 : float = 100.0) -> void:
	自身参数 = 按钮参数
	self.text = str(自身参数)
	self.size.x = 宽度
	self.size.y = 高度
