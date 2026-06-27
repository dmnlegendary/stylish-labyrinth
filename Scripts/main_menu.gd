extends Control

@onready var mute_button = $ButtonContainer/MuteButton

func _ready() -> void:
	# Make sure the mouse cursor is a standard arrow when the menu loads
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	# We also make sure PlayerUI is disabled
	if PlayerUi:
		PlayerUi.visible = false
	
	# Optional: If you want the background music from your Autoload to play here,
	# and it isn't playing yet, you can trigger it:
	# BackgroundMusic.play()

func _on_play_button_pressed() -> void:
	# We reset the character status and we load the portrait of it
	PlayerUi.reset_stats()
	PlayerUi.visible = true
	
	# Load the main_room scene
	get_tree().change_scene_to_file("res://Scenes/room_main.tscn")


func _on_mute_button_pressed() -> void:
	# 1. Get the master audio bus (this controls ALL sound in the game)
	var master_bus = AudioServer.get_bus_index("Master")
	
	# 2. Check if it is currently muted
	var is_muted = AudioServer.is_bus_mute(master_bus)
	
	# 3. Flip the mute state (if true, make false. If false, make true)
	AudioServer.set_bus_mute(master_bus, not is_muted)
	
	# 4. Update the button text so the player knows what it does
	if not is_muted:
		mute_button.text = "UNMUTE"
	else:
		mute_button.text = "MUTE"


func _on_exit_button_pressed() -> void:
	# Close the game
	get_tree().quit(0)
