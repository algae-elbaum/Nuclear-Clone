extends "res://src/projectile.gd"

const SPLIT_ANGLE = .3 # rads
const SPLIT_COOLDOWN = .25 # seconds
var cooldown_timer = SPLIT_COOLDOWN
var plain_projectile = preload("res://src/projectile.tscn")

func clone_at_angle(split_angle):
	var new_dir = vel.rotated(split_angle)
	var clone = plain_projectile.instance()
	clone.set_pos(get_global_pos())
	get_tree().get_root().get_node("map").add_child(clone)
	clone.fire(get_global_pos() + new_dir, ignore_entities, ignore_groups)

func _fixed_process(delta):
	cooldown_timer -= delta
	if (cooldown_timer <= 0):
		cooldown_timer = SPLIT_COOLDOWN
		clone_at_angle(SPLIT_ANGLE)
		clone_at_angle(-SPLIT_ANGLE)
		