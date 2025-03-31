extends Camera2D

# 相机节点
@export var camera : Camera2D
# 路径的起点和终点
@export var start_position : Vector2 = Vector2(0, 0)
@export var end_position : Vector2 = Vector2(1000, 0)
# 移动时间（单位：秒）
@export var move_duration : float = 5.0

# 内部变量
var time_passed : float = 0.0

func _ready() -> void:
		# 确保相机最初的位置是起点
			camera.position = start_position
			
func _process(delta) -> void:
					# 计算经过的时间t
						time_passed += delta
						
							# 计算相机的位置，沿着路径从start到end
						var progress = time_passed / move_duration
								
									# 确保不会超出路径
						if progress > 1:
							progress = 1
							camera.position =  start_position
							time_passed = 0
													
														# 通过线性插值（lerp）计算相机位置
						var new_position = start_position.lerp(end_position, progress)
						camera.position = new_position
																	# 如果相机移动完成，可以在这里执行一些后续操作
						if progress == 1:
																					# 比如停留在终点，或执行其他操作
							pass
