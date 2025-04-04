extends Node

var 世界数据路径 : String = "res://存储/世界/星区列表.json"
var 世界数据文件

var 世界数据 : Dictionary

var 初始世界数据 : Dictionary = {
	"星区" : {
		"00" : {
			"已生成" : true,
			"基地" : true
			},
		"11" : {
			"已生成" : true,
			"基地" : false
			}
		}
	}

func _ready() -> void:
	世界数据路径 = "res://存储/世界/星区列表.json"

func 读取世界() -> void:
	if FileAccess.file_exists(世界数据路径) :
		世界数据 = Core.读取文件(世界数据路径 , "json")
	for 星区ID in 世界数据["星区"]:
		var 星区数据 = 世界数据["星区"][星区ID]
		print("星区id" , 星区ID)
		print("已生成" , 星区数据["已生成"])
		
func 初始化世界() -> void:
	世界数据文件 = FileAccess.open(世界数据路径 , FileAccess.WRITE)
	if  世界数据文件 == null:
		print("无法创建世界数据文件")
	世界数据文件.store_string(JSON.stringify(初始世界数据))
	世界数据文件.close()

func 计算星区(坐标 : Vector2) -> void:
	pass

func 保存世界() -> void:
	pass
