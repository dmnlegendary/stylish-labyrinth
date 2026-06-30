extends Node2D

# Export variables to assign scenes in the Inspector
@export_file("*.tscn") var trap_door_scene: String
@export_file("*.tscn") var empty_door_scene: String
@export_file("*.tscn") var exit_door_scene: String

# Grab references to the visual polygons you just created
@onready var left_highlight = $"DoorLeftArea/Polygon2D"
@onready var center_highlight = $"DoorCenterArea/Polygon2D"
@onready var right_highlight = $"DoorRightArea/Polygon2D"

# Grab references to the Audio nodes
@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound

# Variable to control the transition into rooms
var trapTrigger: int = 70 - (PlayerUi.rooms_crossed*5)
var nothingTrigger: int = 20 + (PlayerUi.rooms_crossed*5)
var escapeTrigger: int = 10

# Variable to control the transition between rooms
# Tracks if the player has already clicked on a door
var is_transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# In this case is not necesary to load anything prior the scene itself
	# Except for when walking animation is over
	PlayerUi.refresh_idle_state()
	
	# Set a seed for random numbers
	randomize()
	
	# 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# --- HERE LIES THE LOGIC THAT HANDLES WHEN PLAYER CLICKS ON ANY DOOR

func _on_door_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check if the event is a mouse button press, and specifically the Left click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Left door clicked...moving to the next room")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		enter_door("left")

func _on_door_center_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Center door clicked...moving to the next room")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		enter_door("center")

func _on_door_right_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Right door clicked...moving to the next room")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		enter_door("right")
		
# --- CUSTOM HELPER FUNCTION ---

func enter_door(door_chosen: String):
	# If the player already chose to move to another room then no need to run this function
	if is_transitioning == true:
		return
	else:
		is_transitioning = true
	
	# We make sure the mouse hover icon is back to arrow form
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	# We run walking animation
	PlayerUi.start_walking()
	
	# Play the click sound immediately!
	click_sound.play()
	print("Player clicked the ", door_chosen, " door.")
	
	# Optional: If you are going to change scenes right away, 
	# the sound might get cut off. We can tell Godot to wait 
	# for the sound to finish before moving on!
	await click_sound.finished
	
	print("Moving to the next room...")
	# Scene changing code will go here later
	# The formula to calculate which room is gonna be loaded after is:
	# For trap_room: 70% and we decrease it for 5% each time the player crosses a room
	var probability_for_player = randi_range(1, 100)
	print("La probabilidad obtenida fue de: ", probability_for_player)
	
	
	# Lets determine which scene is gonna be loaded after
	var next_scene_path = ""
	
	# We also set the dialogue options for the dialogue box to display
	var choice: String
	var text_for_doors: Array[String] = [
		"You push against a heavy barrier. It groans as it drags across the stone floor...",
		"You step forward into a shadowed passage. The air feels thick and uncertain...",
		"The surface chills your hand as you move it aside. A cold draft seeps into the chamber..."
		]
	# Ensure the array is not empty before selecting
	if text_for_doors.size() > 0:
		# Pick a random element
		var random_index = randi() % text_for_doors.size()
		choice = text_for_doors[random_index]
		print("Random choice:", choice)
	else:
		print("The array is empty.")
	# Here we trigger the dialogue box
	PlayerUi.show_dialogue(choice)
	# Wait for player to read it
	get_tree().create_timer(7).timeout
	PlayerUi.hide_dialogue()
	
	if probability_for_player <= trapTrigger:
		next_scene_path = trap_door_scene
	elif probability_for_player > trapTrigger and probability_for_player <= 100-escapeTrigger:
		next_scene_path = empty_door_scene
	elif probability_for_player > trapTrigger + nothingTrigger:
		next_scene_path = exit_door_scene
		
	if PlayerUi.rooms_crossed <= 10:
		PlayerUi.rooms_crossed = PlayerUi.rooms_crossed + 1
	
	print("The amount of ",PlayerUi.rooms_crossed, " rooms have been crossed")
	print("While the rates for triggers (trap, empty and exit) are:\n", trapTrigger, ",", nothingTrigger, ",", escapeTrigger)
		
	# After setting up which room is gonna be selected
	if next_scene_path != "":
		# This is the Godot function that swaps the current scene for a new one
		await get_tree().change_scene_to_file(next_scene_path)
	else:
		print("Careful! No scene is assigned to the ", door_chosen, " door yet.")

# --- HOVER ON DOOR LOGIC WHILE PLAYER IS IN THE SCENE---

func _on_door_left_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	# Turns the highlight on
	left_highlight.visible = true
	hover_sound.play()

func _on_door_left_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	# Turns the highlight off
	left_highlight.visible = false


func _on_door_center_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	center_highlight.visible = true
	hover_sound.play()

func _on_door_center_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	center_highlight.visible = false


func _on_door_right_area_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	right_highlight.visible = true
	hover_sound.play()

func _on_door_right_area_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	right_highlight.visible = false
