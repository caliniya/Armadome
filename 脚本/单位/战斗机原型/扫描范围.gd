extends Area2D

enum 类型 {战舰 , 战斗机 , 子弹}

var 自身阵营
var 敌人列表 = []
var 自身类型
var 父节点
var 本体

func _ready() -> void:
	父节点 = get_parent()
	本体 = 父节点.get_node("本体")
	自身阵营 = 父节点.自身阵营
	自身类型 = 父节点.自身类型
		
func  单位进入(area:Area2D) -> void:
	if area.自身阵营 == 自身阵营 and area.自身类型 == 类型.子弹:
		pass
	else :
		敌人列表.append(area)
		area.被锁定 = true
		pass
		
func  单位离开(area:Area2D) -> void:
	if area.自身阵营 == 自身阵营 and area.自身类型 == 类型.子弹:
		pass
	else :
		area.被锁定 = false
		敌人列表.erase(area)
