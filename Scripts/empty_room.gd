extends Node2D

# The main hall to return and choose a new door
@export_file("*.tscn") var main_hallway_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUi.refresh_idle_state()
	print("Empty room. Safe for now.")
	
	# Wait for 5 seconds to read and watch
	await get_tree().create_timer(5.0).timeout
	
	# Walking back to hallway
	PlayerUi.start_walking()
	
	# Wait half a second for the walk animation to play
	await get_tree().create_timer(0.5).timeout
	
	if main_hallway_scene != "":
		get_tree().change_scene_to_file(main_hallway_scene)
	else:
		print("Careful! No return scene is assigned in the inspector yet.")
