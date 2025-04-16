extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	World.初始化世界()
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self ,"modulate:a" , 0.0 , 1.0).set_delay(0.5)
	tween.tween_property(self ,"modulate:a" , 1.0 , 1.0).set_delay(0.5)
	tween.set_loops()
	World.读取世界()
	World.生成唯一ID表()
	print(World.星区唯一ID表)	
	var 场景 = preload("res://场景/世界/世界.tscn").instantiate()
	await get_tree().create_timer(4.0).timeout
	Core.从实例切换场景(场景)
