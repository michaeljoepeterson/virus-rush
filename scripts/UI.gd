extends CanvasLayer

onready var move_radial = $windowUI/move_group/moveProgress
onready var infect_radial = $windowUI/infectProgress
onready var att_radial = $windowUI/attackProgres
onready var defend_radial = $windowUI/defendProgress
onready var turns = $windowUI/turns
onready var moveNum = $windowUI/move_group/moveProgress/moveNum
onready var uparrow = $windowUI/move_group/uparrow

var move = 0
var infect = 0
var attack = 0
var defend = 0
export var turn = 201


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_puzzle_move_update(move, infect, attack, defend)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_puzzle_move_update(mover, infecter, attacker, defender):
	move = mover
	move_radial.progress = move
	moveNum.text = String(move)
	infect = infecter
	infect_radial.progress = infect
	attack = attacker
	att_radial.progress = attack
	defend = defender
	defend_radial.progress = defend
	turn -= 1
	turns.text = String(turn)


func _on_Move_pressed():
	if move > 0:
		uparrow.visible = true
		print("Move")
