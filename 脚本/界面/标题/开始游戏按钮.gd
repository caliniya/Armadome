extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func 跳转() -> void:
	# 读取场景的资源, 4.4新增的这个文件自动补全可太棒了!!!
	var 场景实例 = preload("res://场景/世界/世界预加载.tscn").instantiate()# 填 1 表示可修改实例

	Core.从实例切换场景(场景实例)
	
	
	
	
	
	
	
	
	
