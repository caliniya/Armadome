class_name 战舰原型
extends Node2D

@export var 核心容量 : float = 1000
@export var 护甲容量 : float = 1000
@export var 护甲值 : float = 20
@export var 护盾容量 : float = 1000
@export var 最大速度 : float = 400
@export var 标准转向速度 : float = 1
@export var 标准加速度 : float = 200
@export var 标准减速度 : float = 200
@export var 货仓容量 : float = 100
@export var 自身质量 : float = 10000
@export var 扫描范围 : float = 500
@export var 储能上限 : float = 10000
@export var 回充速率 : float = 1000
@export var 能量栅格 : float = 2000
@export var 能量屏蔽 : float = 0.2
@export var 穿甲抗性 : float = 0.2
@export var 穿透抗性 : float = 0.2
@export var 回复速度 : float = 200
@export var 破盾延迟 : float = 5
@export var 护盾耗能 : float = 100
@export var 跳跃速度 : float = 10
@export var 自身阵营 : String = 变量.阵营[0] #默认蓝队
@export var 弹药库容量 : float = 1000
@export var 速度比例 : float = 0.7

@export var 内部唯一ID : int

var 武器缓存 : Node

var 舰体宽度 : float
var 舰体长度 : float
var 舰体对角线 : float

var 加速度 : float
var 减速度 : float
var 转向速度 : float
var 负重速度 : float

var 当前护盾容量 : float
var 当前护甲容量 : float
var 当前核心容量 : float
var 当前弹药库容量 : float
var 当前能量水平 : float

var 星区坐标 : Vector2

var 实际速度 : float = 0
var 目标方向 : Vector2
var 目标距离 : float
var 减速距离 : float
var 期望速度 : float
var 移动方向 : Vector2
var 需要提前减速 : bool
var 目标角度差 : float
var 每帧转向量 : float
var 实际转向速度 : float
var 预计转向时间 : float
var 预计到达时间 : float

var 武器接口 : Dictionary = {
	"0" : {
		"级别" : 1,
		"坐标" : Vector2(31,12),
		"类型" : "弹药",
	},
	"1" : {
		"级别" : 1,
		"坐标" : Vector2(-32,12),
		"类型" : "弹药",
	}
}

var 武器 : Dictionary = {
	"0" : {
		"类型" : "微风",
		"电容" : 0.0,
		"弹药" : 0
	},
	"1" : {
		"类型" : "微风",
		"电容" : 0.0,
		"弹药" : 0
		}
}

var 武器信息 : Dictionary

var 本体 : Node
var 本体形状节点 : CollisionShape2D
var 本体形状 : CapsuleShape2D

var 移动目标方向
var 移动目标坐标 : Vector2
var 移动量 : Vector2
var 当前坐标 : Vector2

var 选中 : bool

@export var 货仓装载体积 : float = 0
@export var 货仓装载质量 : float = 0
@export var 货仓货物 : Array = []

func 加载武器() -> void:
	for 序列 in 武器:
		武器缓存 = 变量.武器[武器[序列]["类型"]].new()
		武器缓存.初始化武器(自身阵营 ,self ,武器[序列]["弹药"] , 武器[序列]["电容"])
		本体.add_child(武器缓存)
		武器缓存.position = 武器接口[序列]["坐标"]

func _ready() -> void:
	本体 = get_node("本体")
	本体形状节点 = 本体.get_node("本体形状")
	if 本体形状节点.shape is CapsuleShape2D:
		本体形状 = 本体形状节点.shape
		舰体宽度 = 本体形状.radius
		舰体长度 = 本体形状.height + (2 * 舰体宽度)
	舰体对角线 = sqrt(pow(舰体长度 , 2) + pow(舰体宽度 , 2))
	选中 = true
	单位.载重更新(self)
	加载武器()

func _process(delta: float) -> void:
	向目标移动(delta)

func 向目标移动(帧差值 : float) -> void:
	目标方向 = 移动目标坐标 - global_position
	目标距离 = 目标方向.length()
	
	if 目标距离 < 5:
		实际速度 = 0
		global_position = 移动目标坐标
		移动目标坐标 = global_position
		return
		
	移动目标方向 = ((移动目标坐标 - global_position).normalized()).angle() + PI / 2
	
	目标角度差 = 移动目标方向 - 本体.rotation
	目标角度差 = fposmod(目标角度差 + PI , TAU) - PI
	每帧转向量 = 实际转向速度 * 帧差值
	
	实际转向速度 = 转向速度 * min((实际速度 / (负重速度 * 速度比例)) , 1.0)
	
	预计转向时间 = abs(目标角度差) / 实际转向速度
	预计到达时间 = 目标距离 / 实际速度 if 实际速度 > 0 else INF
	
	if 预计转向时间 > 预计到达时间 and 目标距离 < 舰体长度:
		需要提前减速 = true
	else :
		需要提前减速 = false
	
	if abs(目标角度差) <= 每帧转向量:
		本体.rotation = 移动目标方向
		移动目标方向 = 本体.rotation
	else:
		本体.rotation += sign(目标角度差) * 每帧转向量
	
	减速距离 = (pow(实际速度 , 2) / (2 * 减速度)) if 减速度 > 0 else  INF
	
	if 目标距离 <= 减速距离 or 需要提前减速 :
		if 实际速度 > 0:
			实际速度 -= 减速度 * 帧差值
			实际速度 = max(实际速度 , 0)
	else :
		期望速度 = min(负重速度 , sqrt(2 * 加速度 * 目标距离))
		实际速度 = move_toward(实际速度 , 期望速度 , 加速度 * 帧差值)
	
	
	
	移动方向 = Vector2(0,-1).rotated(本体.rotation)
	global_position += 移动方向 * 实际速度 * 帧差值
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventSingleScreenTap and 选中 == true :
		移动目标坐标 = get_global_mouse_position()
