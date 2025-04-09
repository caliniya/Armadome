extends MenuButton

func _ready() -> void:
	get_popup().hide_on_item_selection = false
	for 星区 in World.星区ID列表:
		var ID = World.星区唯一ID表.get(星区)
		get_popup().add_item("星区" + str(ID) , ID)
		get_popup().add_theme_font_size_override("font_size" , 40)

func 按下() -> void:
	if button_pressed == false:
		set_process(true)
		show_popup()
	print(button_pressed)
	set_process(false)
