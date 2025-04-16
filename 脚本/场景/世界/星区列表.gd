extends MenuButton

var 展开 : bool = true

func _ready() -> void:
	get_popup().hide_on_item_selection = false
	for 星区 in World.星区ID列表:
		var ID = World.星区唯一ID表.get(星区)
		get_popup().add_item("星区" + str(ID) , ID)
		get_popup().add_theme_font_size_override("font_size" , 40)

func 按下() -> void:
	展开 = !展开
	if 展开 == false:
		set_pressed(true)
		show_popup()
		return
	set_pressed(false)
