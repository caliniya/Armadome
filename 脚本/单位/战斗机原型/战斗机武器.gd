extends Area2D

var 自身阵营
var 敌人列表 = []
@export var 子弹 :PackedScene
var 目标选择计时器 = -10
var 射击计时器 = 0.5
var 目标距离列表 = []
var 目标距离 = 400
var 敌人距离 : float
var 目标 : Area2D
var 目标方向
var 目标角度
var 当前角度
var 旋转速度 = 3
var 父节点
var 本体

func _ready() -> void:
	父节点 = get_parent()
	自身阵营 = 父节点.自身阵营
	本体 = 父节点.get_node("本体")

func _process(delta: float) -> void:
	目标选择计时器 -= delta
	射击计时器 -= delta
	if 目标选择计时器 < 0:
		目标选择()
	
	if 目标 != null:
		转向(delta)
		

func  单位进入(area:Area2D) -> void:
	if area.自身阵营 == 自身阵营:
		pass
	else :
		敌人列表.append(area)
		if 目标选择计时器 < 0:
			目标选择()
			print(目标)
			

func  单位离开(area:Area2D) -> void:
	if area.自身阵营 == 自身阵营:
		pass
	else :
		敌人列表.erase(area)

func  目标选择() -> void:
	for 敌人 in 敌人列表:
		敌人距离 =  global_position.distance_to(敌人.global_position)
		print(敌人距离)
		if 敌人距离 < 目标距离:
			目标距离 = 敌人距离
			目标 = 敌人
	目标选择计时器 = 1
	目标距离 = 325

func 转向(delta: float) -> void:
	目标方向 = (目标.global_position - 本体.global_position).normalized()
	目标角度 = 目标方向.angle() + PI / 2
	当前角度 = 本体.rotation
	本体.rotation = lerp_angle(当前角度, 目标角度, 旋转速度 * delta)
