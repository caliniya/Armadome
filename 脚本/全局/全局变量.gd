extends Node

const 货物质量 : Dictionary = {"测试货物一号":1000.0}

const 货物体积 : Dictionary = {"测试货物一号":10.0}

const 阵营 : Array = ["肃清" , "帝国" , "封锁" , "叛军"]

var 阵营友好关系: Dictionary = {
	"肃清" : {
		"帝国" : true,
		"封锁" : false,
		"叛军" : false,
	},
	"帝国" : {
		"肃清" : true,
		"封锁" : false,
		"叛军" : false,
	},
	"封锁" : {
		"肃清" : false,
		"帝国" : false,
		"叛军" : true,
	},
	
}

var 单位 : Dictionary = {
	"风吹" : 风吹,
}

var 武器 : Dictionary = {
	"微风" : 微风,
}

var 文件路径表 : Dictionary = {
	"星区列表路径" :  "res://存储/世界/星区列表.json",
	"星区文件夹路径" :  "res://存储/世界/星区/",
	"单位ID表路径" :  "res://存储/世界/单位ID表.json",
	"单位坐标ID表路径" : "res://存储/世界/单位坐标.json",
	"单位数据路径" :  "res://存储/世界/单位/星区",
	"世界数据路径" :  "res://存储/世界",
	
}
