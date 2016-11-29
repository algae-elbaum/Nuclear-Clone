
extends KinematicBody2D

const BASE_WALKING_SPEED = 400 # pixels per second
var vel = Vector2(0, 0)

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
	set_fixed_process(true)
	set_process_input(true)
