extends Node2D

export (String) var color
var move_tween


# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween = get_node("Tween")

func dim(amount):
	var sprite = get_node("Sprite")
	sprite.modulate = Color(1, 1, 1, amount)

func move(target):
	move_tween.interpolate_property(self, "position", position, target, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
