extends Control

var fading: String = "none" #can be "in" (-alpha) or "out" (+alpha)
const FADETIME: float = 2.0

func _ready() -> void:
	$LoadingScreen.visible = false
	$FadeBlack.visible = false

#Menu Button Callbacks:

func _on_NewGame_pressed() -> void:
	if fading == "none":
		$FadeBlack.visible = true
		$FadeTimer.start(FADETIME/1.5)
		fading = "out"

func _on_LoadGame_pressed() -> void:
	print("load game does not exist yet.") #would not switch to a new scene

func _on_Settings_pressed() -> void:
	print("settings does not exist yet.") #same here

func _on_Exit_pressed() -> void:
	$ConfirmationDialog.popup()

func _on_ConfirmationDialog_confirmed() -> void:
	get_tree().quit()

#timeout callback, to control the fade-to-black
func _on_FadeTimer_timeout() -> void:
	if fading == "out": #fading the screen's contents out to black
		$LoadingScreen.visible = true
		print("fadeout completed")
		fading = "in" #now fading the screen's contents in from black
		$FadeTimer.start(FADETIME)
	elif fading == "in": #elif here, or a "return" on the line above prevents immediate scene changing
		print("fadeout completed")
		fading = "none"
		$FadeBlack.visible = false
		yield(get_tree(), 'idle_frame')
		global.goto_scene("res://src/levels/3DPlayground.tscn")

#fading in action, except not actually using delta for anything yet
func _process(_delta: float) -> void:
	if fading == "out":
		$FadeBlack.color = Color(0,0,0,($FadeTimer.wait_time-$FadeTimer.time_left))
	if fading == "in":
		$FadeBlack.color = Color(0,0,0,($FadeTimer.time_left/$FadeTimer.wait_time))
	#print($FadeTimer.time_left)
