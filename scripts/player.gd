extends KinematicBody2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
onready var wall_ray = get_node("wallRay")
signal move_remove


func _physics_process(_delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)

func _on_uparrow_pressed():
	emit_signal("move_remove")
	target = position + Vector2(0,-64)

func _on_rightarrow_pressed():
	emit_signal("move_remove")
	target = position + Vector2(64,0)

func _on_leftarrow_pressed():
	emit_signal("move_remove")
	target = position + Vector2(-64,0)

func _on_downarrow_pressed():
	emit_signal("move_remove")
	target = position + Vector2(0,64)
