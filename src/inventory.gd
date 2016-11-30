
extends Node

var active = {}

# Fire the active items
func fire_active(global_mouse_pos, ignore_entities=[], ignore_groups=[]):
	for k in active:
		# Spawn new projectile only if off cooldown
		if (active[k]["cooldown"]):
			continue
		var shot = active[k]["scene"].instance()
		active[k]["cooldown"] = shot.cooldown
		# Prep shot for autonomous motion
		shot.set_pos(get_global_pos())
		get_node("/root/map").add_child(shot)
		# Let it know its target so it can get going
		shot.fire(global_mouse_pos, ignore_entities, ignore_groups)

func set_active(name, path):
	active[name] = {"scene": load(path),
					"cooldown": 0}

func _process(delta):
	for k in active:
		active[k]["cooldown"] = max(0, active[k]["cooldown"] - delta)

func _ready():
	set_process(true)
	pass


