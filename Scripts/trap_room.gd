extends Node2D

@export_file("*.tscn") var main_hallway_scene: String
@export_file("*.tscn") var main_menu_scene: String

func _ready():
	PlayerUi.refresh_idle_state()
	
	# Here we load the dialogue
	PlayerUi.show_dialogue("You step on a loose stone. A heavy shackle snaps around your wrist.")
	
	# Trigger the trap instantly when they enter
	print("Trap triggered! Restraint level increased.")
	PlayerUi.increase_restraint()
	
	# Wait for 10 seconds so the player sees their status change
	await get_tree().create_timer(10.0).timeout
	# 2. Hide the dialogue before walking away
	PlayerUi.hide_dialogue()
	
	# Start walking back to the hallway
	if PlayerUi.restraint_level < 4:
		PlayerUi.start_walking()
	
		# Wait half a second for the walk animation to play
		await get_tree().create_timer(1).timeout
	
		if main_hallway_scene != "":
			get_tree().change_scene_to_file(main_hallway_scene)
		else:
			print("Careful! No return scene is assigned in the inspector yet.")
	else:
		if main_menu_scene != "":
			# we show a new dialogue where player is defeated
			PlayerUi.show_dialogue("YOU WERE TOTALLY RESTRAINED! YOU CANNOT MOVE! SELFLESS AND CARELESS!")
			get_tree().create_timer(10).timeout
			PlayerUi.hide_dialogue()
			get_tree().change_scene_to_file(main_menu_scene)
		else:
			print("Careful! No Main Menu scene is assigned in the inspector yet.")
