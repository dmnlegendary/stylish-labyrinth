extends CanvasLayer

var restraint_level: int = 0
var status: String = "Free"

@onready var status_label = $Panel/Label
@onready var portrait = $Panel/CharacterPortrait
@onready var timer_for_testing = $Timer

func _ready():
	#timer_for_testing.start(5)
	refresh_idle_state()

# 1. This function checks the current level and plays the correct idle pose
func refresh_idle_state():
	status_label.text = "Restraint Level: " + str(restraint_level) + "/4\nStatus: " + status
	
	if restraint_level == 0:
		portrait.play("idle1_free")
	elif restraint_level == 1:
		portrait.play("idle2_stage1")
	elif restraint_level == 2:
		portrait.play("idle3_stage2")
	elif restraint_level == 3:
		portrait.play("idle4_stage3")

# 2. Trap rooms will call this function!
func increase_restraint():
	restraint_level += 1
	
	if restraint_level == 1:
		status = "Slightly Bound"
	elif restraint_level == 2:
		status = "Tightly Bound"
	elif restraint_level == 3:
		status = "Heavily Restrained"
	elif restraint_level >= 4:
		status = "Captured!"
		status_label.text = "Restraint Level: " + str(restraint_level) + "/4\nStatus: " + status
		trigger_game_over()
		return # Stop running the code here so we don't try to play animation 4
		
	# Update the animation and text
	refresh_idle_state()

# 3. The doors will call this function!
func start_walking():
	portrait.play("walk_free")

func trigger_game_over():
	portrait.play("gameover_restrained")
	print("Game Over! The player was fully restrained.")
	# Here you will eventually use get_tree().change_scene_to_file("res://GameOver.tscn")

func _on_timer_timeout() -> void:
	increase_restraint()

func reset_stats():
	var restraint_level: int = 0
	var status: String = "Free"
