extends KinematicBody2D

onready var wall_up = get_node("wallup")
onready var wall_right = get_node("wallright")
onready var wall_left = get_node("wallleft")
onready var wall_down = get_node("walldown")
onready var bad_guy_hit = get_node("bad_guy_1")

export (int) var speed = 20
var velocity = Vector2()

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if velocity == Vector2.ZERO:
		if !wall_up.is_colliding():
			velocity.y = -speed 
		elif !wall_right.is_colliding():
			velocity.x = speed 
		elif !wall_left.is_colliding():
			velocity.x = -speed 
		elif !wall_down.is_colliding():
			velocity.y = speed 
		
	velocity = move_and_slide(velocity)

func _on_bad_guy_1_area_entered(_area):
	self.queue_free()
