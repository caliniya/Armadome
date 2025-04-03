extends Area2D

var 根节点 : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	根节点 = get_tree().current_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
