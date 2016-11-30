extends Container

const OFFSET = Vector2(-140, -140)

func _ready():
	pass

func show_menu():
	get_tree().set_pause(true)
	var player_pos = get_node("/root/map/player").get_global_pos()
	set_global_pos(player_pos + OFFSET)
	# Don't want Esc bringing up main menu. What's the better way of doing this?
	get_node("/root/map/main_menu").set_process_input(false)
	self.show()

func _on_new_game_button_released():
	hide()
	get_node("/root/map/main_menu").set_process_input(true)
	get_node("/root/map/main_menu").new_game()


func _on_end_game_button_released():
	get_tree().quit()
