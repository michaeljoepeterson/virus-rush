extends KinematicBody2D

var MAX_SPEED = 500
var ACCELERTION = 2000
var motion = Vector2()
onready var wall_ray = get_node("wallRay")

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERTION * delta)
	else:
		apply_motion(axis * ACCELERTION * delta)
	motion = move_and_slide(motion)
	# print(wall_ray.get_collision_point())

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_motion(accelertion):
	motion += accelertion
	motion = motion.clamped(MAX_SPEED)


func _on_uparrow_pressed():
	pass
	
