extends Node2D

@export var 网格单元大小 := Vector2(256, 256)    # 每个网格单元格的尺寸
@export var 主网格颜色 := Color.WHITE          # 主网格线颜色
@export var 次要网格颜色 := Color(1,1,1,0.5)  # 次要网格线颜色
@export var 主网格线间隔 := 1                  # 主网格线间隔（单位：单元格数）
@export var 线条宽度 := 1.0                   # 基础线条粗细
@export var 使用虚线 := false       # 是否使用虚线样式
@export var 虚线实线屏幕长度 := 10.0           # 虚线实线部分屏幕像素长度
@export var 虚线间隔屏幕长度 := 20.0           # 虚线间隔部分屏幕像素长度
@export var 绘制网格点 := true                # 是否在交叉点绘制圆点
@export var 网格点颜色 := Color.WHITE         # 网格点颜色
@export var 网格点半径 := 4.0                 # 网格点屏幕半径

var 上一次相机位置: Vector2
var 上一次缩放: Vector2

var 点击坐标 : Vector2
var 点击世界坐标 : Vector2
var 当前选中网格 : Vector2i


func _process(_delta):
	var 相机 = get_viewport().get_camera_2d()
	if 相机 and (相机.position != 上一次相机位置 or 相机.zoom != 上一次缩放):
		queue_redraw()
		上一次相机位置 = 相机.position
		上一次缩放 = 相机.zoom

func _draw():
	var 相机 = get_viewport().get_camera_2d()
	if not 相机:
		return

	# 计算可见区域边界
	var 视口 = get_viewport()
	var 视口尺寸 = Vector2(视口.get_visible_rect().size) / 相机.zoom
	var 左上角 = 相机.position - 视口尺寸 / 2
	var 右下角 = 相机.position + 视口尺寸 / 2

	# 初始化坐标收集数组
	var 水平线y坐标数组 = []
	var 垂直线x坐标数组 = []

	# 水平线计算
	var 水平线起始y = floor(左上角.y / 网格单元大小.y) * 网格单元大小.y
	var 水平线结束y = ceil(右下角.y / 网格单元大小.y) * 网格单元大小.y
	var 水平线起点x = floor(左上角.x / 网格单元大小.x - 1) * 网格单元大小.x
	var 水平线终点x = ceil(右下角.x / 网格单元大小.x + 1) * 网格单元大小.x

	# 绘制水平网格
	for y坐标 in range(水平线起始y, 水平线结束y + 网格单元大小.y, 网格单元大小.y):
		水平线y坐标数组.append(y坐标)
		var line_index = int(y坐标 / 网格单元大小.y)
		var is_main = (line_index % 主网格线间隔) == 0
		var current_color = 主网格颜色 if is_main else 次要网格颜色
		var current_width = 线条宽度 * (2.0 if is_main else 1.0)
		
		if 使用虚线:
			绘制虚线(
				Vector2(水平线起点x, y坐标),
				Vector2(水平线终点x, y坐标),
				current_color,
				current_width,
				相机.zoom
			)
		else:
			draw_line(
				Vector2(水平线起点x, y坐标),
				Vector2(水平线终点x, y坐标),
				current_color,
				current_width / 相机.zoom.x
			)

	# 垂直线计算
	var 垂直线起始x = floor(左上角.x / 网格单元大小.x) * 网格单元大小.x
	var 垂直线结束x = ceil(右下角.x / 网格单元大小.x) * 网格单元大小.x
	var 垂直线起点y = floor(左上角.y / 网格单元大小.y - 1) * 网格单元大小.y
	var 垂直线终点y = ceil(右下角.y / 网格单元大小.y + 1) * 网格单元大小.y

	# 绘制垂直网格
	for x坐标 in range(垂直线起始x, 垂直线结束x + 网格单元大小.x, 网格单元大小.x):
		垂直线x坐标数组.append(x坐标)
		var line_index = int(x坐标 / 网格单元大小.x)
		var is_main = (line_index % 主网格线间隔) == 0
		var current_color = 主网格颜色 if is_main else 次要网格颜色
		var current_width = 线条宽度 * (2.0 if is_main else 1.0)
		
		if 使用虚线:
			绘制虚线(
				Vector2(x坐标, 垂直线起点y),
				Vector2(x坐标, 垂直线终点y),
				current_color,
				current_width,
				相机.zoom
			)
		else:
			draw_line(
				Vector2(x坐标, 垂直线起点y),
				Vector2(x坐标, 垂直线终点y),
				current_color,
				current_width / 相机.zoom.x
			)

	# 绘制网格交叉点
	if 绘制网格点:
		for x in 垂直线x坐标数组:
			for y in 水平线y坐标数组:
				draw_circle(
					Vector2(x, y),
					网格点半径 / 相机.zoom.x,
					网格点颜色
				)

func 绘制虚线(起点: Vector2, 终点: Vector2, color: Color, width: float, zoom: Vector2):
	var 方向 = (终点 - 起点).normalized()
	var 总长度 = 起点.distance_to(终点)
	var 当前位置 = 0.0
	var 绘制实线 = true
	
	# 计算世界坐标系中的虚线长度
	var dash_length = 虚线实线屏幕长度 / zoom.x
	var gap_length = 虚线间隔屏幕长度 / zoom.x

	while 当前位置 < 总长度:
		var 段长度 = dash_length if 绘制实线 else gap_length
		段长度 = min(段长度, 总长度 - 当前位置)
		
		if 绘制实线:
			var 段起点 = 起点 + 方向 * 当前位置
			var 段终点 = 段起点 + 方向 * 段长度
			draw_line(段起点, 段终点, color, width / zoom.x)
		
		当前位置 += 段长度
		绘制实线 = not 绘制实线

func _input(event: InputEvent) -> void:
	if event is InputEventSingleScreenTap:
		点击坐标 = event.position
		点击世界坐标 = get_local_mouse_position()
		当前选中网格 = 计算网格坐标(点击世界坐标)
		print(当前选中网格)

func 计算网格坐标(世界坐标 : Vector2) -> Vector2i :
	return Vector2i(floori(世界坐标.x / 网格单元大小.x),floori(世界坐标.y / 网格单元大小.x))
