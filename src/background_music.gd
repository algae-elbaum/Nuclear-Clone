extends StreamPlayer

func new_song(name):
	set_stream(load("assets/background_music/" + name))
	play()

func defeated():
	set_volume(1)
	set_loop(false)
	new_song("Super Mario Bros. Music - Game Over-5Wc3kwv0Ddw.ogg")
	
func victory():
	set_volume(1)
	set_loop(true)
	new_song("Trails in the Sky Musical Selections  - Target Vanquished!-z7rtcZ11O88.ogg")

func new_game():
	set_volume(.5)
	set_loop(true)
	new_song("Comptine D`un Autre Été - L`ap.ogg")

func _ready():
	new_game()
