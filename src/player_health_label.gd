extends Label

var max_health

func _ready():
	pass

func set_max_health(new_max):
	max_health = str(new_max)

func set_health(new_health):
	set_text(str(new_health) + "/" + max_health + ", Stay Alive!")