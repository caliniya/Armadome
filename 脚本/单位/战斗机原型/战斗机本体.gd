# 战舰主体脚本（附加到战舰Area2D）
extends Area2D

# 阵营
enum 阵营 {蓝队 , 红队, 黄队}
enum 类型 {战舰 , 战斗机 , 子弹}

var 自身阵营
var 血量 := 1000
var 自身类型
@export var 被锁定 := false

var 父节点

func  _ready() -> void:
	if 被锁定 == true:
		pass
	父节点 = get_parent()
	自身阵营 = 父节点.自身阵营
	自身类型 = 父节点.自身类型
	父节点.血量 = 血量
