
extends Area2D

const BASE_SPEED = 500
var vel = Vector2(0, 0)

var damage = 1
var cooldown = .25

# Spawns a clone of self moving in the direction of x, y
func fire(global_target_pos, inherited_velocity):
	vel = global_target_pos - get_pos()
	vel = BASE_SPEED * vel.normalized()
	# If we don't adjust for this case, then clicking exactly the right place
	# leaves a dir=0 bullet, which is basically just a mine. kinda interesting,
	# but not quite intended.
	if (vel == Vector2(0, 0)):
		vel = Vector2(1, 0)
		
	# And inherit velocity from shooter
	vel = vel + inherited_velocity
	
	set_fixed_process(true)

func delete():
	# Shut everything down in case queue_free takes a while
	set_fixed_process(false)
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	queue_free()

func _on_projectile_body_enter(body):
	if (body.get_name() == "player"):
		return
	if (body.has_method("take_damage")):
		body.take_damage(damage)
	delete()

func _fixed_process(delta):
	translate(vel * delta)

func _ready():
	# To be 100% clear:
	set_fixed_process(false)
	# We do not want to process until we're given a target x,y.


