extends Node2D

@export_file("*.tscn") var main_hallway_scene: String
@export_file("*.tscn") var main_menu_scene: String

func _ready():
	PlayerUi.refresh_idle_state()
	
	# Trigger the trap instantly when they enter
	print("Trap triggered! Restraint level increased.")
	PlayerUi.increase_restraint()
	
	# Wait for 2 seconds so the player sees their status change
	await get_tree().create_timer(5.0).timeout
	
	# Start walking back to the hallway
	if PlayerUi.restraint_level < 4:
		PlayerUi.start_walking()
	
		# Wait half a second for the walk animation to play
		await get_tree().create_timer(0.5).timeout
	
		if main_hallway_scene != "":
			get_tree().change_scene_to_file(main_hallway_scene)
		else:
			print("Careful! No return scene is assigned in the inspector yet.")
	else:
		if main_menu_scene != "":
			get_tree().change_scene_to_file(main_menu_scene)
		else:
			print("Careful! No Main Menu scene is assigned in the inspector yet.")
