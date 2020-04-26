extends Node2D

export (String) var color
var move_tween

func _ready():
	move_tween = get_node("Tween")

func dim(amount):
	var sprite = get_node("Sprite")
	sprite.modulate = Color(1, 1, 1, amount)

func move(target):
	move_tween.interpolate_property(self, "position", position, target, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	move_tween.start()

func move_out(target):
	move_tween.interpolate_property(self, "position", position, target, .25, Tween.TRANS_SINE, Tween.EASE_IN)
	move_tween.start()
