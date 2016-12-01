extends Container

const OFFSET = Vector2(-140, -140)

onready var main_menu = get_node("/root/map/HUD_canvas/main_menu")

func _ready():
	pass

func show_menu():
	get_tree().set_pause(true)
	# Don't want Esc bringing up main menu. What's the better way of doing this?
	main_menu.set_process_input(false)
	self.show()

func _on_new_game_button_released():
	hide()
	main_menu.set_process_input(true)
	main_menu.new_game()


func _on_end_game_button_released():
	get_tree().quit()
