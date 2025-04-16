extends Control

var 星区列表节点 : Node
var 点击坐标 : Vector2


func _ready() -> void:
	星区列表节点 = get_node("MenuButton")

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventSingleScreenTap:
		点击坐标 = event.position
		if 点击坐标.x <= 250 and 点击坐标.y <= 100:
			星区列表节点.按下()
			return
