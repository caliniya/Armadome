extends Control

var 世界节点 : Node2D

func _ready() -> void:
	世界节点 = get_parent().get_parent()
	

func 按钮按下() -> void:
	if self.visible == true:
		self.visible = false
	else :
		self.visible = true
	世界节点.星区列表切换()
