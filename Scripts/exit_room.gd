extends Node2D

# This room goes back to the main menu instead of the hallway
@export_file("*.tscn") var main_menu_scene: String

func _ready():
	PlayerUi.refresh_idle_state()
	print("You found the exit!")
	
	# Wait for 3 seconds so the player can process their victory
	await get_tree().create_timer(5.0).timeout
	
	# Play the walk animation as they escape
	# PlayerUi.start_walking()
	
	# Optional: wait a moment for the walk animation to play before transitioning
	await get_tree().create_timer(0.5).timeout
			
	if main_menu_scene != "":
		get_tree().change_scene_to_file(main_menu_scene)
	else:
		print("Careful! No Main Menu scene is assigned in the inspector yet.")
