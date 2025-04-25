class_name 战舰原型
extends Node2D

@export var 核心容量 : float = 1000
@export var 装甲容量 : float = 1000
@export var 护甲值 : float = 20
@export var 护盾容量 : float = 1000
@export var 最大速度 : float =4
@export var 标准转向速度 : float = 1
@export var 标准加速度 : float = 1
@export var 标准减速度 : float = 1
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

@export var 内部唯一ID : int = 00000000

var 当前弹药库容量 : float
var 加速度 : float
var 减速度 : float
var 转向速度 : float
var 负重速度 : float

var 当前护盾容量 : float
var 当前装甲容量 : float
var 当前核心容量 : float

var 本体 : Node

var 移动目标方向
var 移动目标坐标 : Vector2
var 移动量 : Vector2

var 选中 : bool

@export var 货仓装载体积 : float = 0
@export var 货仓装载质量 : float = 0
@export var 货仓货物 : Array = []

func _ready() -> void:
	本体 = get_node("本体")
	选中 = true
	单位.载重更新(self)
	单位.装载货物("测试货物一号" , self)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	向目标移动(delta)	

func 向目标移动(帧差值 : float) -> void:
	移动目标方向 = ((移动目标坐标 - global_position).normalized()).angle() + PI / 2
	本体.rotation = lerp_angle(本体.rotation, 移动目标方向, 转向速度 * 帧差值)
	移动量 = Vector2(0,-负重速度).rotated(本体.rotation)
	global_position += 移动量

func _input(event: InputEvent) -> void:
	if event is InputEventSingleScreenTap and 选中 == true :
		移动目标坐标 = get_global_mouse_position()
