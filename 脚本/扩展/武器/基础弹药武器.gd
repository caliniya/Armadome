class_name 基础弹药武器 
extends Area2D

var 武器级别 : int
var 弹仓容量 : float
var 射击耗弹 : float
var 旋转速度 : float
var 不精准度 : float
var 有效射程 : float
var 射击耗能 : float
var 射击间隔 : float
var 索敌距离 : float
var 装填速度 : float
var 电容容量 : float
var 放电效率 : float
var 充能速率 : float
var 短路耗能 : float
var 离线延迟 : float
var 电场强度 : float

var 镜像武器 : bool
var 镜像武器实例 : 基础弹药武器 = null

var 武器贴图路径 : String
var 武器主贴图 : Script

var 当前弹仓容量 : float
var 当前电容水平 : float

var 武器搭载平台 : Node
var 武器隶属阵营 : String

var 装填计时器 : float
var 射击计时器 : float
var 充能计时器 : float

var 索敌区域 : Area2D
var 索敌形状 : CollisionShape2D
var 射程区域 : Area2D
var 射程形状 : CollisionShape2D

func 能否安装(接口级别 : int) -> bool:
	if 武器级别 >= 接口级别:
		return true
	return false

func 初始化武器(阵营 : String , 搭载平台 : Node , 弹仓量 : float , 电容水平 : float) -> void:
	武器搭载平台 = 搭载平台
	武器隶属阵营 = 阵营
	当前弹仓容量 = 弹仓量
	当前电容水平 = 电容水平
	初始化射程区域()
	初始化索敌区域()
	

func _physics_process(delta: float) -> void:
	装填计时器 += delta
	射击计时器 += delta
	充能计时器 += delta
	装填(delta)

func 可以射击() -> bool:
	return(当前弹仓容量 >= 射击耗弹 and 当前电容水平 >= 射击耗能 and 射击计时器 >= 射击间隔)

func 装填(帧时间 : float) -> bool:
	if 武器搭载平台.当前弹药库容量 > 1.0 and 装填计时器 >= 1.0:
		当前弹仓容量 += 装填速度
		武器搭载平台.当前弹药库容量 -= 装填速度
		装填计时器 = 0
		return true
	return false

func 初始化索敌区域() -> void:	
	索敌区域 = Area2D.new()
	add_child(索敌区域)
	索敌形状 = CollisionShape2D.new()
	索敌形状.shape = CircleShape2D.new()
	索敌形状.shape.radius = 索敌距离
	索敌区域.add_child(索敌形状)

func 初始化射程区域() -> void:
	射程区域 = self
	射程形状 = CollisionShape2D.new()
	射程形状.shape = CircleShape2D.new()
	射程形状.shape.radius = 有效射程
	射程区域.add_child(射程形状)

func 充能() -> void:
	pass
