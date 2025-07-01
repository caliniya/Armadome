class_name 导航
extends Node

static func 由目标计算路线(目标坐标 : Vector2) -> void:
	pass
	
static func 计算移动参数(战舰: 战舰原型,目标位置: Vector2,delta: float) -> Dictionary:
	var 目标方向 = 目标位置 - 战舰.global_position
	var 目标距离 = 目标方向.length()
	
	# 如果已经到达目标
	if 目标距离 < 5:
		return {
			"速度": 0,
			"位置": 目标位置,
			"旋转": 战舰.本体.rotation
		}
	
	# 计算方向相关参数
	var 移动目标方向 = ((目标位置 - 战舰.global_position).normalized()).angle() + PI / 2
	var 目标角度差 = 移动目标方向 - 战舰.本体.rotation
	目标角度差 = fposmod(目标角度差 + PI, TAU) - PI
	
	# 计算转向速度
	var 实际转向速度 = 战舰.转向速度 * min((战舰.实际速度 / (战舰.负重速度 * 战舰.速度比例)), 1.0)
	var 每帧转向量 = 实际转向速度 * delta
	
	# 预测转向和到达时间
	var 预计转向时间 = abs(目标角度差) / 实际转向速度
	var 预计到达时间 = 目标距离 / 战舰.实际速度 if 战舰.实际速度 > 0 else INF
	
	# 判断是否需要提前减速
	var 需要提前减速 = (预计转向时间 > 预计到达时间 and 目标距离 < 战舰.舰体长度)
	
	# 计算旋转
	var 新旋转 = 战舰.本体.rotation
	if abs(目标角度差) <= 每帧转向量:
		新旋转 = 移动目标方向
	else:
		新旋转 += sign(目标角度差) * 每帧转向量
	
	# 计算速度
	var 减速距离 = (pow(战舰.实际速度, 2) / (2 * 战舰.减速度)) if 战舰.减速度 > 0 else INF
	var 新速度 = 战舰.实际速度
	
	if 目标距离 <= 减速距离 or 需要提前减速:
		if 新速度 > 0:
			新速度 -= 战舰.减速度 * delta
			新速度 = max(新速度, 0)
	else:
		var 期望速度 = min(战舰.负重速度, sqrt(2 * 战舰.加速度 * 目标距离))
		新速度 = move_toward(新速度, 期望速度, 战舰.加速度 * delta)
	
	# 计算新位置
	var 移动方向 = Vector2(0, -1).rotated(新旋转)
	var 新位置 = 战舰.global_position + 移动方向 * 新速度 * delta
	
	return {
		"速度": 新速度,
		"位置": 新位置,
		"旋转": 新旋转
	}
