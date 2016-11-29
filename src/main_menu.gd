extends Container

const OFFSET = Vector2(-500, -240)
const INIT_COOLDOWN = 1 # second
const COOLDOWN_MAX = 5 # seconds

var player = preload("res://src/player.tscn")
var cooldown = INIT_COOLDOWN

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if (event.is_action_pressed("menu")):
		var player_pos = get_node("/root/map/player").get_global_pos()
		set_global_pos(player_pos + OFFSET)
		self.show()
		cooldown = COOLDOWN_MAX

func _process(delta):
	cooldown -= delta
	if (cooldown <= 0):
		hide()

func _on_end_game_button_released():
	get_tree().quit()

func _on_new_game_button_released():
	# Kill all the enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.destruct()
	for proj in get_tree().get_nodes_in_group("projectiles"):
		proj.destruct()
	# Reset the player
	get_node("/root/map/player").destruct()
	var new_player = player.instance()
	new_player.set_global_pos(Vector2(0,0))
	new_player.set_name("player")
	get_node("/root/map").add_child(new_player)
	# Move menu to center in case esc was pressed during the game
	set_global_pos(OFFSET)
	cooldown = INIT_COOLDOWN
	# And generate a new level
	get_node("/root/map/level_generator").generate_naive_random_level()