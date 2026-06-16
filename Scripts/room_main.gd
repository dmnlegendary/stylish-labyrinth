extends Node2D

# Export variables to assign scenes in the Inspector
@export_file("*.tscn") var left_door_scene: String
@export_file("*.tscn") var center_door_scene: String
@export_file("*.tscn") var right_door_scene: String

# Grab references to the visual polygons you just created
@onready var left_highlight = $"DoorLeftArea/Polygon2D"
@onready var center_highlight = $"DoorCenterArea/Polygon2D"
@onready var right_highlight = $"DoorRightArea/Polygon2D"

# Grab references to the Audio nodes
@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound

# Variable to control the transition between rooms
# Tracks if the player has already clicked on a door
var is_transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# In this case is not necesary to load anything prior the scene itself
	pass # Replace with function body.


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
	
	
	# Play the click sound immediately!
	click_sound.play()
	print("Player clicked the ", door_chosen, " door.")
	
	# Optional: If you are going to change scenes right away, 
	# the sound might get cut off. We can tell Godot to wait 
	# for the sound to finish before moving on!
	await click_sound.finished
	
	print("Moving to the next room...")
	# Scene changing code will go here later
	
	# Lets determine which scene is gonna be loaded after
	var next_scene_path = ""
	
	if door_chosen == "left":
		next_scene_path = left_door_scene
	elif door_chosen == "center":
		next_scene_path = center_door_scene
	elif door_chosen == "right":
		next_scene_path = right_door_scene
		
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
