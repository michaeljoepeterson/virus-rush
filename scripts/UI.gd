extends CanvasLayer

onready var move_radial = $windowUI/moveProgress
onready var infect_radial = $windowUI/infectProgress
onready var att_radial = $windowUI/attackProgres
onready var defend_radial = $windowUI/defendProgress
onready var turns = $windowUI/turns
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
	move += mover
	move_radial.progress = move
	infect += infecter
	infect_radial.progress = infect
	attack += attacker
	att_radial.progress = attack
	defend += defender
	defend_radial.progress = defend
	turn -= 1
	turns.text = String(turn)
