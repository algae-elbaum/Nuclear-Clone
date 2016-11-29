
extends Area2D

const BASE_SPEED = 600
var vel = Vector2(0, 0)

var damage = 1
var cooldown = .3

# Determines what entities are not affected by the projectile.
var ignore_entities
var ignore_groups

# Spawns a clone of self moving in the direction of x, y
func fire(global_target_pos, ignore_entities=[], ignore_groups=[]):
	vel = global_target_pos - get_pos()
	vel = BASE_SPEED * vel.normalized()
	# If we don't adjust for this case, then clicking exactly the right place
	# leaves a dir=0 bullet, which is basically just a mine. kinda interesting,
	# but not quite intended.
	if (vel == Vector2(0, 0)):
		vel = Vector2(1, 0)

	self.ignore_entities = ignore_entities
	self.ignore_groups = ignore_groups
	# TODO animate/sound
	set_fixed_process(true)

func destruct():
	# TODO animate/sound
	# Shut everything down in case queue_free takes a while
	set_fixed_process(false)
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	queue_free()

func _on_projectile_body_enter(body):
	for i in ignore_entities:
		if (body == i):
			return
	for i in ignore_groups:
		var ignore_ents = get_tree().get_nodes_in_group(i)
		if (body in ignore_ents):
			return

	if (body.has_method("take_damage")):
		body.take_damage(damage)
	destruct()

func _fixed_process(delta):
	translate(vel * delta)

func _ready():
	add_to_group("projectiles")
	# To be 100% clear:
	set_fixed_process(false)
	# We do not want to process until we're given a target x,y.


