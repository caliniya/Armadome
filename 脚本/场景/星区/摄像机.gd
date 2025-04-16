extends Camera2D

# 配置
@export var 最大缩放: float = 2
@export var 最小缩放: float = 0.7

enum 缩放手势枚举 { 禁用, 捏合 }
enum 旋转手势枚举 { 禁用, 扭转 }
enum 移动手势枚举 { 禁用, 单指拖拽, 多指拖拽 }

@export var 缩放手势: 缩放手势枚举 = 缩放手势枚举.禁用 
@export var 旋转手势: 旋转手势枚举 = 旋转手势枚举.扭转
@export var 移动手势: 移动手势枚举 = 移动手势枚举.单指拖拽

var 有效左边界 = -1500
var 有效右边界 = 1500
var 有效顶部边界 = -1500
var 有效底部边界 = 1500

func 设置相机位置(p):
	var 相机限制范围
	var 相机尺寸 = 获取相机尺寸() / zoom

	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		相机限制范围 = [
			Vector2(),
			Vector2(相机尺寸.x, 0),            
			Vector2(0, 相机尺寸.y),
			Vector2(相机尺寸.x, 相机尺寸.y),
			Vector2(相机尺寸.x, 0)
		]
	elif anchor_mode == ANCHOR_MODE_DRAG_CENTER:
		相机限制范围 = [
			Vector2(-相机尺寸.x/2, -相机尺寸.y/2),
			Vector2(相机尺寸.x/2, -相机尺寸.y/2),
			Vector2(相机尺寸.x/2, 相机尺寸.y/2),
			Vector2(-相机尺寸.x/2, 相机尺寸.y/2)
		]

	for i in 相机限制范围.size():
		相机限制范围[i] = 相机限制范围[i].rotated(rotation)

	for 限制点 in 相机限制范围:
		if p.x > 有效右边界 - 限制点.x:
			p.x = 有效右边界 - 限制点.x
		if p.y > 有效底部边界 - 限制点.y:
			p.y = 有效底部边界 - 限制点.y
		if p.x < 有效左边界 - 限制点.x:
			p.x = 有效左边界 - 限制点.x
		if p.y < 有效顶部边界 - 限制点.y:
			p.y = 有效顶部边界 - 限制点.y

	for 限制点 in 相机限制范围:
		if (p.x > 有效右边界 - 限制点.x) or (p.y > 有效底部边界 - 限制点.y) or (p.x < 有效左边界 - 限制点.x) or (p.y < 有效顶部边界 - 限制点.y):
			return false

	position = p
	return true

func _unhandled_input(事件):
	if (事件 is InputEventMultiScreenDrag and 移动手势 == 移动手势枚举.多指拖拽) or (事件 is InputEventSingleScreenDrag and 移动手势 == 移动手势枚举.单指拖拽):
		_移动(事件)
	elif 事件 is InputEventScreenTwist and 旋转手势 == 旋转手势枚举.扭转:
		_旋转(事件)
	elif 事件 is InputEventScreenPinch and 缩放手势 == 缩放手势枚举.捏合:
		_缩放(事件)

# 将相机局部坐标转换为全局坐标
func 相机坐标转全局坐标(位置):
	var 相机中心 = global_position
	var 相对相机中心偏移 = 位置 - 获取相机中心偏移()
	return 相机中心 + (相对相机中心偏移 / zoom).rotated(rotation)

func _移动(事件):
	设置相机位置(position - (事件.relative / zoom).rotated(rotation))

func _缩放(事件):
	var 初始距离 = 事件.distance
	var 最终距离 = 事件.distance - 事件.relative
	var 初始缩放 = zoom.x
	var 最终缩放 = (初始距离 * 初始缩放) / 最终距离
	var 缩放变化量 = 最终缩放 - 初始缩放

	if 最终缩放 <= 最小缩放 and sign(缩放变化量) < 0:
		最终缩放 = 最小缩放
		缩放变化量 = 最终缩放 - 初始缩放
	elif 最终缩放 >= 最大缩放 and sign(缩放变化量) > 0:
		最终缩放 = 最大缩放
		缩放变化量 = 最终缩放 - 初始缩放

	zoom = Vector2(最终缩放, 最终缩放)

	var 相对相机中心偏移 = 事件.position - 获取相机中心偏移()
	var 相对位移 = (相对相机中心偏移 * 缩放变化量) / (初始缩放 * 最终缩放)
	if not 设置相机位置(position + 相对位移.rotated(rotation)):
		zoom = Vector2(初始缩放, 初始缩放)

func _旋转(事件):
	if ignore_rotation: return

	var 相对相机中心偏移 = 事件.position - 获取相机中心偏移()
	var 反向旋转偏移 = -相对相机中心偏移.rotated(事件.relative)

	rotation -= 事件.relative

	if not 设置相机位置(position - ((反向旋转偏移 + 相对相机中心偏移) / zoom).rotated(rotation - 事件.relative)):
		rotation += 事件.relative

func 获取相机中心偏移():
	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		return Vector2.ZERO
	elif anchor_mode == ANCHOR_MODE_DRAG_CENTER:
		return 获取相机尺寸() / 2

func 获取相机尺寸():
	return get_viewport().get_visible_rect().size

func _ready():
	var 临时左边界 = 有效左边界
	有效左边界 = limit_left
	limit_left = 临时左边界

	var 临时右边界 = 有效右边界
	有效右边界 = limit_right
	limit_right = 临时右边界

	var 临时顶部边界 = 有效顶部边界
	有效顶部边界 = limit_top
	limit_top = 临时顶部边界

	var 临时底部边界 = 有效底部边界
	有效底部边界 = limit_bottom
	limit_bottom = 临时底部边界

	设置相机位置(position)
