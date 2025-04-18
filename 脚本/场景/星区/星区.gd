extends Node2D

# ================== 网格显示参数 ==================
@export var 网格单元大小 := Vector2(300, 300)    # 每个网格单元格的尺寸（单位：像素）
@export var 主网格颜色 := Color.WHITE          # 主网格线颜色
@export var 次要网格颜色 := Color(1,1,1,0.5)  # 次要网格线颜色（半透明白色）
@export var 主网格线间隔 := 1                  # 主网格线间隔（单位：单元格数）
@export var 线条宽度 := 1.0                   # 基础线条粗细（单位：像素）
@export var 使用虚线 := false                 # 是否使用虚线样式
@export var 虚线实线屏幕长度 := 10.0           # 虚线实线部分屏幕像素长度
@export var 虚线间隔屏幕长度 := 20.0           # 虚线间隔部分屏幕像素长度

# ================== 网格点参数 ==================
@export var 绘制网格点 := true                # 是否在交叉点绘制圆点
@export var 网格点颜色 := Color.WHITE         # 网格点颜色
@export var 网格点半径 := 4.0                 # 网格点屏幕半径（单位：像素）

# ================== 网格坐标显示参数 ==================
@export var 显示网格坐标 := true              # 是否显示网格坐标文本
@export var 坐标字体颜色 := Color.WHITE       # 坐标文本颜色
@export var 坐标字体大小 := 30               # 基础字体大小（会根据缩放自动调整）
@export var 坐标字体 : Font                 # 可选自定义字体（留空使用引擎默认字体）

var ID显示节点 : Node 
var 星区ID : String

# ================== 运行时变量 ==================
var 上一次相机位置: Vector2
var 上一次缩放: Vector2
var 星区列表节点 : Node
var 点击坐标 : Vector2
var 点击世界坐标 : Vector2
var 当前选中网格 : Vector2i
var 鼠标网格 : Vector2i

# ================== 引擎回调 ==================
func _ready() -> void:
	ID显示节点 = get_node("UI/Control/Label")

func _process(_delta):
	# 相机变化检测（触发重绘）
	var 相机 = get_viewport().get_camera_2d()
	if 相机 and (相机.position != 上一次相机位置 or 相机.zoom != 上一次缩放):
		queue_redraw()
		上一次相机位置 = 相机.position
		上一次缩放 = 相机.zoom

func _draw():
	var 相机 = get_viewport().get_camera_2d()
	if not 相机:
		return

	# ================== 可见区域计算 ==================
	var 视口 = get_viewport()
	var 视口尺寸 = Vector2(视口.get_visible_rect().size) / 相机.zoom
	var 左上角 = 相机.position - 视口尺寸 / 2
	var 右下角 = 相机.position + 视口尺寸 / 2

	# ================== 网格线绘制 ==================
	var 水平线y坐标数组 = []
	var 垂直线x坐标数组 = []

	# 水平线绘制
	var 水平线起始y = floor(左上角.y / 网格单元大小.y) * 网格单元大小.y
	var 水平线结束y = ceil(右下角.y / 网格单元大小.y) * 网格单元大小.y
	var 水平线起点x = floor(左上角.x / 网格单元大小.x - 1) * 网格单元大小.x
	var 水平线终点x = ceil(右下角.x / 网格单元大小.x + 1) * 网格单元大小.x

	for y坐标 in range(水平线起始y, 水平线结束y + 网格单元大小.y, 网格单元大小.y):
		水平线y坐标数组.append(y坐标)
		var line_index = int(y坐标 / 网格单元大小.y)
		var is_main = (line_index % 主网格线间隔) == 0
		var current_color = 主网格颜色 if is_main else 次要网格颜色
		var current_width = 线条宽度 * (2.0 if is_main else 1.0)
		
		if 使用虚线:
			绘制虚线(Vector2(水平线起点x, y坐标), Vector2(水平线终点x, y坐标), 
				current_color, current_width, 相机.zoom)
		else:
			draw_line(Vector2(水平线起点x, y坐标), Vector2(水平线终点x, y坐标),
				current_color, current_width / 相机.zoom.x)

	# 垂直线绘制
	var 垂直线起始x = floor(左上角.x / 网格单元大小.x) * 网格单元大小.x
	var 垂直线结束x = ceil(右下角.x / 网格单元大小.x) * 网格单元大小.x
	var 垂直线起点y = floor(左上角.y / 网格单元大小.y - 1) * 网格单元大小.y
	var 垂直线终点y = ceil(右下角.y / 网格单元大小.y + 1) * 网格单元大小.y

	for x坐标 in range(垂直线起始x, 垂直线结束x + 网格单元大小.x, 网格单元大小.x):
		垂直线x坐标数组.append(x坐标)
		var line_index = int(x坐标 / 网格单元大小.x)
		var is_main = (line_index % 主网格线间隔) == 0
		var current_color = 主网格颜色 if is_main else 次要网格颜色
		var current_width = 线条宽度 * (2.0 if is_main else 1.0)
		
		if 使用虚线:
			绘制虚线(Vector2(x坐标, 垂直线起点y), Vector2(x坐标, 垂直线终点y),
				current_color, current_width, 相机.zoom)
		else:
			draw_line(Vector2(x坐标, 垂直线起点y), Vector2(x坐标, 垂直线终点y),
				current_color, current_width / 相机.zoom.x)

	# ================== 网格点绘制 ==================
	if 绘制网格点:
		for x in 垂直线x坐标数组:
			for y in 水平线y坐标数组:
				draw_circle(Vector2(x, y), 网格点半径 / 相机.zoom.x, 网格点颜色)

	# ================== 网格坐标绘制 ==================
	if 显示网格坐标:
		# 字体设置（使用自定义字体或引擎默认）
		var 实际字体 = 坐标字体 if 坐标字体 else ThemeDB.fallback_font
		# 根据缩放调整字体大小（保持屏幕显示尺寸一致）
		var 缩放字体大小 = 坐标字体大小 / 相机.zoom.x
		# 文本位置偏移（防止覆盖网格点）
		var 文本偏移 = Vector2(5 + 缩放字体大小 * 0.0, 5 + 缩放字体大小 * 1.0)  # 纵向居中偏移
		
		for x in 垂直线x坐标数组:
			for y in 水平线y坐标数组:
				# 计算网格逻辑坐标
				var 网格坐标x = int(x / 网格单元大小.x)
				var 网格坐标y = int(y / 网格单元大小.y)
				# 生成坐标文本（格式示例：(3,-5)）
				var 坐标文本 = "(%d,%d)" % [网格坐标x, 网格坐标y]
				# 计算绘制位置（左上角偏移）
				var 绘制位置 = Vector2(x, y) + 文本偏移
				# 实际绘制文本
				draw_string(实际字体, 绘制位置, 坐标文本, 
					HORIZONTAL_ALIGNMENT_LEFT, -1, 缩放字体大小, 坐标字体颜色)

	# ================== 选中网格高亮 ==================
	if 当前选中网格 != null:
		var 颜色 = 主网格颜色.clamp()
		颜色.a = 0.4
		draw_colored_polygon(世界.获取网格轮廓(当前选中网格, 网格单元大小), 颜色)
		draw_polyline(世界.获取网格轮廓(鼠标网格, 网格单元大小), 颜色, 线条宽度*16)

# ================== 虚线绘制函数 ==================
func 绘制虚线(起点: Vector2, 终点: Vector2, color: Color, width: float, zoom: Vector2):
	var 方向 = (终点 - 起点).normalized()
	var 总长度 = 起点.distance_to(终点)
	var 当前位置 = 0.0
	var 绘制实线 = true
	
	# 将屏幕像素长度转换为世界坐标长度
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

# ================== 输入处理 ==================
func _input(event: InputEvent) -> void:
	# 鼠标交互处理
	if event is InputEventSingleScreenDrag or InputEventSingleScreenTap:
		鼠标网格 = 世界.计算星区(get_local_mouse_position(), 网格单元大小) 
		queue_redraw()

	# 点击事件处理
	if event is InputEventSingleScreenTap:
		点击坐标 = event.position
		
		# 网格选择逻辑
		点击世界坐标 = get_local_mouse_position()
		当前选中网格 = 世界.计算星区(点击世界坐标, 网格单元大小)
		print("选中网格：", 当前选中网格)
