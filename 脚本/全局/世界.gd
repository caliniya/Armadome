extends Node

var 世界数据路径 : String = "res://存储/世界/星区列表.json"
var 星区文件夹路径 : String = "res://存储/世界/星区/"
var 单位列表路径 :String = "res;//存储/世界/单位列表.json"

var 初始世界数据 : Dictionary = {
	"星区" : {
		"0,0" : {
			"已生成" : true,
			"基地" : true,
			"坐标" : [0 , 0]
			},
		"1,1" : {
			"已生成" : true,
			"基地" : false,
			"坐标" : [1 , 1]
			},
		"1,0" : {
			"已生成" : true,
			"基地" : false,
			"坐标" : [1 , 0]
			}
		}
	}

var 空星区世界 : Dictionary = {
	"空间站" : {
		"类型" : "默认",
		"坐标" : [0 ,0],
	},
	"建筑" : [
		
	],
	"单位" : [
		
	]
}

var 初始单位列表 : Array =[
	{"00000000" : "风吹"}
]

var 世界数据 : Dictionary
var 星区列表 : Array
var 星区唯一ID表 : Dictionary
var 星区唯一ID表反向映射 : Dictionary

func _ready() -> void:
	世界数据路径 = "res://存储/世界/星区列表.json"

func 读取世界() -> void:
	生成星区列表()
	生成唯一ID表()

func 初始化世界() -> void:
	方法.删除非空文件夹( "res://存储/世界/")
	方法.覆写文件(世界数据路径,初始世界数据)
	生成星区列表()
	生成唯一ID表()
	初始化星区文件()
	初始化单位列表文件()


func 计算星区(世界坐标 : Vector2 , 网格单元大小 : Vector2) -> Vector2i :
	return Vector2i(floori(世界坐标.x / 网格单元大小.x),floori(世界坐标.y / 网格单元大小.y))
	
func 计算星区ID(星区坐标 : Vector2i) -> String:
	return str(计算唯一ID(星区坐标.x , 星区坐标.y))

func 获取网格轮廓(顶点位置:Vector2 , 网格单元大小) -> PackedVector2Array:
	var 一格长 = 网格单元大小.x
	顶点位置 *= 一格长
	var 顶点组 = PackedVector2Array()
	顶点组.append(顶点位置)# 开始, 左上角
	顶点组.append(Vector2(顶点位置.x + 一格长,顶点位置.y))# 右上角
	顶点组.append(Vector2(顶点位置.x + 一格长,顶点位置.y + 一格长))# 右下角
	顶点组.append(Vector2(顶点位置.x,顶点位置.y + 一格长))#左下角
	顶点组.append(顶点位置)# 结束, 回到左上角 以闭合.
	return 顶点组

func 存在星区(星区ID : String) -> bool:
	if 星区唯一ID表反向映射.has(int(星区ID)):
		return true
	return false

func 保存世界() -> void:
	pass

func 生成唯一ID表() -> void:
	for 星区ID in 世界数据["星区"]:
		var x = 世界数据["星区"][星区ID]["坐标"].get(0)
		var y = 世界数据["星区"][星区ID]["坐标"].get(1)
		var 唯一ID = 计算唯一ID(x , y)
		星区唯一ID表.set(星区ID , 唯一ID)
	星区唯一ID表反向映射 = 反向映射字典(星区唯一ID表)

func 反向映射字典(字典 : Dictionary) -> Dictionary:
	var 反向字典 : Dictionary
	for 键 in 字典 :
		反向字典[字典[键]] = 键
	return 反向字典

func 计算唯一ID(x : int , y : int) -> int:
	var k1
	var k2
	if x >= 0 :
		k1 = x * 2
	else :
		k1 = (x * -2) - 1
	if y >= 0 :
		k2 = y * 2
	else :
		k2 = (y * -2) - 1#归一化，将所有整数转换为自然数数
	return (((k1 + k2) * (k1 + k2 + 1)) / 2) + k2
	#康托尔配对函数

func 生成星区列表() -> void:
	if FileAccess.file_exists(世界数据路径) :
		世界数据 = 方法.读取文件(世界数据路径 , "json")
	for 星区ID in 世界数据["星区"]:
		星区列表.append(星区ID)
		var 星区数据 = 世界数据["星区"][星区ID]

func 初始化星区文件() -> void:
	for 星区 in 星区列表:
		方法.覆写文件(星区文件夹路径 + 星区 + ".json" , 空星区世界)

func 初始化单位列表文件() -> void:
	方法.覆写文件(单位列表路径 , 初始单位列表)
