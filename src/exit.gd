extends Area2D

func _ready():
	pass

func on_player_enter():
	# For now, this is the win condition.
	# In future, will send player to the next level.
	get_node("/root/map/HUD_canvas/win_menu").show_menu()

func _on_exit_body_enter(body):
	if (body.get_name() == "player"):
		on_player_enter()

func destruct():
	set_layer_mask(0)
	set_collision_mask(0)
	hide()
	queue_free()
