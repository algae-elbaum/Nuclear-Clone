
extends KinematicBody2D

const BASE_WALKING_SPEED = 400 # pixels per second
var vel = Vector2(0, 0)
var health = 6
var hit_sfx = "player_hit"

var hit_duration = .1 # How long the player is turned red when hit
var hit_cooldown = 0
var hit_red_shift = 10

func take_damage(dam):
	# TODO animate
	get_node("sprite").set_modulate(Color(hit_red_shift, 1, 1))
	hit_cooldown = hit_duration
	get_node("/root/map/sfx").play(hit_sfx)
	health = health - dam
	get_node("/root/map/HUD_canvas/player_health_label").set_health(health)
	if (health <= 0):
		get_node("/root/map/HUD_canvas/loss_menu").show_menu()
		get_node("/root/map/background_music").defeated()

func destruct():
	# TODO animate/sound
	# Shut everything down in case queue_free takes a while
	set_fixed_process(false)
	set_process_input(false)
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	# Change name so new node with name "player" can be made
	set_name("nothing meaningful")
	queue_free()

func orient_texture(velocity):
	var sprite = get_node("sprite")
	if velocity.x == -1:
		sprite.set_flip_h(true)
	elif velocity.x == 1:
		sprite.set_flip_h(false)
	if velocity.y == -1:
		sprite.set_flip_v(false)
	elif velocity.y == 1:
		sprite.set_flip_v(true)

func _fixed_process(delta):
	# MOVEMENT HANDLING
	var velocity = Vector2(0,0)
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	
	if not (move_left and move_right):
		if move_left:
			velocity.x = -1
		elif move_right:
			velocity.x = 1
	
	if not (move_up and move_down):
		if move_up:
			velocity.y = -1
		elif move_down:
			velocity.y = 1
	orient_texture(velocity)
	velocity = BASE_WALKING_SPEED * velocity.normalized()
	vel = velocity # Record velocity for shooting inheritance
	var motion = move(velocity * delta)
	
	# Compensate for crashing into the wall and immediately stopping
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)

func _process(delta):
	if hit_cooldown > 0:
		hit_cooldown -= delta
		if hit_cooldown <= 0:
			get_node("sprite").set_modulate(Color(1/hit_red_shift, 1, 1))

func _input(event):
	# TODO automatic firing with mouse hold
	if (event.is_action_pressed("fire")):
		# TODO shake screen?
		# TODO animate/sound
		var inv = get_node("inventory")
		inv.fire_active(get_global_mouse_pos(), [self])
	
func _ready():
	var inv = get_node("inventory")
	inv.set_active("projectile", "res://src/tree_proj.tscn")
	get_node("/root/map/HUD_canvas/player_health_label").set_max_health(health)
	get_node("/root/map/HUD_canvas/player_health_label").set_health(health)
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)
