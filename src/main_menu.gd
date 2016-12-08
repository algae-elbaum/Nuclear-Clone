extends Container

func show_menu(for_new_game):
	get_tree().set_pause(true)
	if (for_new_game):
		# Start button, not resume button, should show
		get_node("resume_button").hide()
		get_node("start_button").show()
	else:
		# Resume button, not start button, should show
		get_node("resume_button").show()
		get_node("start_button").hide()
	self.show()

func hide_menu():
	hide()
	get_tree().set_pause(false)

func new_game():
	get_node("/root/map/level_manager").destruct_level()
	get_node("/root/map/level_manager").generate_naive_random_level()
	get_node("/root/map/background_music").new_game()
	show_menu(true)

func _ready():
	show_menu(true)
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("menu")):
		if (is_hidden()):
			show_menu(false)
		else:
			hide_menu()

func _on_end_game_button_released():
	get_tree().quit()

func _on_new_game_button_released():
	new_game()

func _on_resume_button_released():
	hide_menu()

func _on_start_button_released():
	hide_menu()
