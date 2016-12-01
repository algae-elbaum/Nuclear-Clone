extends Node2D

var tilemap
var tileset
var wall
var basic_enemy = preload("res://src/basic_enemy.tscn")
var exit = preload("res://src/exit.tscn")
var player = preload("res://src/player.tscn")
var num_enemies = 0

const EMPTY = -1

var PRESET_1 = {"tilemap": "basic_tilemap",
				"width": 30,
				"height": 30,
				"grid_spacing": 8,
				"min_rooms": 40,
				"max_rooms": 60,
				"max_room_dim": 5,
				"loose_min_enemies": 5,
				"loose_max_enemies": 7,}

var cfg = PRESET_1


# Entity functions

func spawn_enemy(left, top, width, height):
	num_enemies += 1
	get_node("/root/map/HUD_canvas/enemy_count_label").set_count(num_enemies)
	var map = get_node("/root/map")
	var x = left + (randi() % width)
	var y = top + (randi() % height)
	var world_xy = tilemap.map_to_world(Vector2(x, y))
	var new_enemy = basic_enemy.instance()
	new_enemy.set_global_pos(world_xy)
	map.call_deferred("add_child", new_enemy)

# Whenever an enemy is killed, check if they were the last enemy, and if so then
# activate the exit block
func enemy_killed(enemy):
	num_enemies -= 1
	get_node("/root/map/HUD_canvas/enemy_count_label").set_count(num_enemies)
	if (num_enemies <= 0):
		activate_exit(enemy.get_global_pos())

func new_enemies(num):
	num_enemies += num

func activate_exit(pos):
	var new_exit = exit.instance()
	new_exit.set_global_pos(pos)
	get_node("/root/map").add_child(new_exit)


# Tilemap functions

func set_tilemap(tilemap_name):
	tilemap = get_node(tilemap_name)
	tileset = tilemap.get_tileset()
	wall = tileset.find_tile_by_name("wall")

# Fills the given rectangle with the tile of the given tile index
func fill_rect(left, top, right, bottom, tile):
	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			tilemap.set_cell(x, y, tile)

# Clears out a grid in the tilemap. grid parameters specified in cfg variable
func clear_grid():
	var half_width = cfg["width"]/2
	var half_height = cfg["height"]/2
	for x in range(-half_width, half_width, cfg["grid_spacing"]):
		fill_rect(x, -half_height, x, half_height, EMPTY)
	for y in range(-half_height, half_height,cfg["grid_spacing"]):
		fill_rect(-half_width, y, half_width, y, EMPTY)

# Clear a random rectangle (bounds set by cfg variable) and possibly
# spawn an enemy in it
func make_new_room(enemy_probability):
	var left = randi() % cfg["width"] - cfg["width"]/2
	var top = randi() % cfg["height"] - cfg["height"]/2
	var width = 1 + (randi() % cfg["max_room_dim"])
	var height = 1 + (randi() % cfg["max_room_dim"])
	fill_rect(left, top, left + (width - 1), top + (height - 1), EMPTY)
	
	# Potentially also place an enemy in the room
	if (randf() < enemy_probability):
		spawn_enemy(left, top, width, height)
		return true
	return false

# Randomly place rooms around, putting enemies in some, and then clearing out
# a grid to help with connectedness.
func generate_naive_random_level():
	fill_rect(-cfg["width"], -cfg["height"], cfg["width"], cfg["height"], wall)
	fill_rect(-5, -5, 4, 4, EMPTY)
	# Ensure connectedness
	clear_grid()
	# Just clear a whole bunch of random rectangles
	randomize()
	var num_rooms = cfg["min_rooms"] + (randi() % (1 + cfg["max_rooms"] - cfg["min_rooms"]))
	var max_num_enemies = cfg["loose_min_enemies"] + (randi() % (1 + cfg["loose_max_enemies"] - cfg["loose_min_enemies"]))
	# Num and placement of enemies is super imprecise
	var enemy_probability = float(max_num_enemies) / num_rooms
	for i in range(num_rooms):
		var made_enemy = make_new_room(enemy_probability)
		if made_enemy:
			max_num_enemies - 1
		if (max_num_enemies == 0):
			enemy_probability = 0

func destruct_level():
	# Kill all the enemies and projectiles
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.destruct()
	num_enemies = 0
	for proj in get_tree().get_nodes_in_group("projectiles"):
		proj.destruct()
	# Delete the exit entity in case it exists
	get_node("/root/map/exit").destruct()
	# Reset the player
	get_node("/root/map/player").destruct()
	var new_player = player.instance()
	new_player.set_global_pos(Vector2(0,0))
	new_player.set_name("player")
	get_node("/root/map").add_child(new_player)
	new_player.get_node("paparazzi").make_current()

func _ready():
	set_tilemap(cfg["tilemap"])
	generate_naive_random_level()