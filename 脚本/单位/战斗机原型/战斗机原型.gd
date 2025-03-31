extends Node2D

enum 阵营 {蓝队 , 红队, 黄队}
enum 类型 {战舰 , 战斗机 , 子弹}

@export var 自身阵营 = 阵营.蓝队
var 血量
@export var 自身类型 := 类型.战斗机

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
