extends KinematicBody2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
onready var wall_up = get_node("wallup")
onready var wall_right = get_node("wallright")
onready var wall_left = get_node("wallleft")
onready var wall_down = get_node("walldown")
onready var hit_box = get_node("hitbox")

signal move_remove
signal infect_block
signal battle(pos)
signal battle_UI(display)
var hit = false
var low_infect_on = false
var infect_amount = 0
var move_up = false
var move_right = false
var move_left = false
var move_down = false


func _physics_process(_delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
	
	move_up = !wall_up.is_colliding()
	move_right = !wall_right.is_colliding()
	move_left = !wall_left.is_colliding()
	move_down = !wall_down.is_colliding()
	
	if hit :
		emit_signal("battle", target)
		hit = false

func infect_block():
	var block_infect = Vector2(0,0)
	block_infect.x = ceil((target.x - 250) / 128 ) - 1
	block_infect.y = ceil((target.y - 250) / 128 ) - 1
	if low_infect_on && infect_amount >= 1:
		emit_signal("infect_block", block_infect)

func _on_uparrow_pressed():
	if move_up:
		emit_signal("move_remove")
		target = position + Vector2(0,-128)
		infect_block()

func _on_rightarrow_pressed():
	if move_right:
		emit_signal("move_remove")
		target = position + Vector2(128,0)
		infect_block()

func _on_leftarrow_pressed():
	if move_left:
		emit_signal("move_remove")
		target = position + Vector2(-128,0)
		infect_block()

func _on_downarrow_pressed():
	if move_down:
		emit_signal("move_remove")
		target = position + Vector2(0,128)
		infect_block()

func _on_infectlow_pressed():
	var block_infect = Vector2(0,0)
	block_infect.x = ceil((position.x - 250) / 128 ) - 1
	block_infect.y = ceil((position.y - 250) / 128 ) - 1
	emit_signal("infect_block", block_infect)
	infect_amount = 2
	low_infect_on = true


func _on_UI_infect_amount(amount):
	infect_amount = amount


func _on_hitbox_area_entered(area):
	if area.get_name() == "bad_guy_1":
		emit_signal("battle_UI", true)
		get_node("battle_delay").start()


func _on_battle_delay_timeout():
	emit_signal("battle", position)


func _on_battle_battelWin():
	emit_signal("battle_UI", false)
