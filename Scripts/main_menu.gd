extends Control

@onready var mute_button = $ButtonContainer/MuteButton

func _ready() -> void:
	# Make sure the mouse cursor is a standard arrow when the menu loads
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	# Optional: If you want the background music from your Autoload to play here,
	# and it isn't playing yet, you can trigger it:
	# BackgroundMusic.play()

func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_mute_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
