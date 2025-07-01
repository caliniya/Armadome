class_name 基础弹药武器 
extends Area2D

var 武器级别 : int = 1
var 弹仓容量 : float = 10.0
var 射击耗弹 : float = 1.0
var 旋转速度 : float = 120.0
var 不精准度 : float = 1.0
var 有效射程 : float = 300.0
var 射击耗能 : float = 10.0
var 射击间隔 : float = 1.0
var 索敌距离 : float = 500.0
var 装填速度 : float = 1.0
var 电容容量 : float = 100.0
var 放电效率 : float = 0.8
var 充能速率 : float = 15.0
var 短路耗能 : float = 50.0
var 离线延迟 : float = 4.0
var 电场强度 : float = 1.0
var 瞄准阈值 : float = 5.0

var 武器贴图路径 : String = "res://素材/实体/武器/一类/微风.png"
var 武器主贴图 : Sprite2D

var 当前弹仓容量 : float
var 当前电容水平 : float

var 武器搭载平台 : Node
var 武器隶属阵营 : String
var 平台武器ID :int

var 装填计时器 : float
var 射击计时器 : float
var 瞄准计时器 : float
var 充能启用 : bool

var 索敌区域 : Area2D
var 索敌形状 : CollisionShape2D
var 射程区域 : Area2D
var 射程形状 : CollisionShape2D

var 索敌列表 : Array
var 射击列表 : Array

func _ready() -> void:
	area_entered.connect(索敌进入)
	area_exited.connect(索敌退出)

func 能否安装(接口级别 : int) -> bool:
	if 武器级别 >= 接口级别:
		return true
	return false

func 初始化武器(阵营 : String , 搭载平台 : Node , 弹仓量 : float , 电容水平 : float , 武器ID : int) -> void:
	武器搭载平台 = 搭载平台
	武器隶属阵营 = 阵营
	当前弹仓容量 = 弹仓量
	当前电容水平 = 电容水平
	平台武器ID = 武器ID
	初始化射程区域()
	初始化索敌区域()
	初始化主贴图()
	

func _physics_process(delta: float) -> void:
	装填计时器 += delta
	射击计时器 += delta
	瞄准计时器 += delta
	装填()
	if 充能启用:
		充能(delta)

func 可以射击() -> bool:
	return(当前弹仓容量 >= 射击耗弹 and 当前电容水平 >= 射击耗能 and 射击计时器 >= 射击间隔)

func 装填() -> bool:
	if 武器搭载平台.当前弹药库容量 > 1.0 and 装填计时器 >= 1.0:
		当前弹仓容量 += 装填速度
		武器搭载平台.当前弹药库容量 -= 装填速度
		装填计时器 = 0
		return true
	return false

func 初始化索敌区域() -> void:	
	索敌区域 = Area2D.new()
	索敌区域.monitorable = false
	add_child(索敌区域)
	索敌形状 = CollisionShape2D.new()
	索敌形状.shape = CircleShape2D.new()
	索敌形状.shape.radius = 索敌距离
	索敌区域.add_child(索敌形状)

func 初始化射程区域() -> void:
	射程区域 = self
	self.monitorable = false
	射程形状 = CollisionShape2D.new()
	射程形状.shape = CircleShape2D.new()
	射程形状.shape.radius = 有效射程
	射程区域.add_child(射程形状)

func 初始化主贴图() -> void:
	武器主贴图 = Sprite2D.new()
	武器主贴图.texture = load(武器贴图路径)	
	add_child(武器主贴图)

func 充能(帧差值 : float) -> void:
	if 武器搭载平台.当前能量水平 >= 1.0 and 当前电容水平 <= 电容容量:
		当前电容水平 += 1.0 * 帧差值
		武器搭载平台.当前能量水平 -= 1.0 * 帧差值

func 索敌进入(进入单位 : Area2D) -> void:
	if 单位.武器目标阵营检查(进入单位  , self):
		充能启用 = true

func 索敌退出(退出单位 : Area2D) -> void:
	if 退出单位 in 索敌列表:
		pass
	
