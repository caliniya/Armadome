extends Node2D

var ID显示节点 : Node 
var 星区ID : String

# ================== 运行时变量 ==================
var 上一次相机位置: Vector2
var 上一次缩放: Vector2
var 星区列表节点 : Node
var 点击坐标 : Vector2
var 点击世界坐标 : Vector2
var 当前选中网格 : Vector2i
var 鼠标网格 : Vector2i

# ================== 引擎回调 ==================
func _ready() -> void:
	ID显示节点 = get_node("UI/Control/ID显示")

# ================== 输入处理 ==================
func _input(event: InputEvent) -> void:
	# 鼠标交互处理
	if event is InputEventSingleScreenDrag or InputEventSingleScreenTap:
		pass

	# 点击事件处理
	if event is InputEventSingleScreenTap:
		点击坐标 = event.position
		
		# 网格选择逻辑
		点击世界坐标 = get_local_mouse_position()

func 初始化星区(加载星区ID : int) -> void:
	pass
