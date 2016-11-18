
extends Node

var active = {"projectile":  {"scene": preload("res://src/projectile.tscn"),
							  "cooldown": 0}}

# Fire the active items
func fire_active(global_mouse_pos, inherited_velocity, ignore):
	for k in active:
		var shot = active[k]["scene"].instance()
		# Check and handle cooldown
		if (active[k]["cooldown"]):
			shot.delete()
			continue
		active[k]["cooldown"] = shot.cooldown
		# If we weren't on cooldown, then we can shoot:
		shot.set_pos(get_global_pos())
		# Put it two parents above, ie the map, so it is not moved by us
		get_node("../..").add_child(shot)
		# Let it know its target so it can get going
		shot.fire(global_mouse_pos, inherited_velocity, ignore)

func _process(delta):
	for k in active:
		active[k]["cooldown"] = max(0, active[k]["cooldown"] - delta)

func _ready():
	set_process(true)
	pass


