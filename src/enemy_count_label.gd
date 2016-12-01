extends Label

const text = " enemies remaining"

func _ready():
	pass

func set_count(new_count):
	set_text(str(new_count) + text)