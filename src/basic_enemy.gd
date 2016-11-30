
extends KinematicBody2D

const BASE_WALKING_SPEED = 200 # pixels per second
var player
var destructed = false
var vel = Vector2(0, 0)
var health = 2
# Even if the enemy sees the player, shoot semi randomly so player can't just
# rely on enemy cooldown to know when they'll shoot
var firing_probability = .005

func detect_player():
	var space_state = get_world_2d().get_direct_space_state()
	var self_pos = get_global_pos()
	var player_pos = player.get_global_pos()
	var result = space_state.intersect_ray(self_pos, player_pos, [ self ])
	return (not result.empty()) and (result["collider"] == player)
	
func consider_firing():
	if (not detect_player()):
		return
	if (randf() < firing_probability):
		var player_pos = player.get_global_pos()
		# TODO animate/sound
		get_node("inventory").fire_active(player_pos, [], ["enemies"])

func destruct():
	# TODO animate/sound
	destructed = true
	get_node("/root/map/level_manager").enemy_killed(self)
	# Shut everything down in case queue_free takes a while
	set_fixed_process(false)
	set_process(false)
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	queue_free()

func take_damage(dam):
	# TODO animate/sound
	health = health - dam
	if (health <= 0 and not destructed):
		destruct()

func update_vel():
	vel = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	vel = BASE_WALKING_SPEED * vel.normalized()

func move_step(delta):
	# TODO animate/sound
	var movement = vel * delta
	if (move(movement) != Vector2(0,0)):
		update_vel()

func _fixed_process(delta):
	move_step(delta)

func _process(delta):
	consider_firing()

func _ready():
	var inv = get_node("inventory")
	inv.set_active("projectile", "res://src/projectile.tscn")
	add_to_group("enemies")
	player = get_node("/root/map/player")
	update_vel()
	add_collision_exception_with(player)
	randomize()
	set_fixed_process(true)
	set_process(true)
