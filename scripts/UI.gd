extends CanvasLayer
# move UI load
onready var move_radial = $windowUI/move_group/moveProgress
onready var moveNum = $windowUI/move_group/moveProgress/moveNum
onready var uparrow = $windowUI/move_group/uparrow
onready var rightarrow = $windowUI/move_group/rightarrow
onready var leftarrow = $windowUI/move_group/leftarrow
onready var downarrow = $windowUI/move_group/downarrow
# infact UI load
onready var infect_radial = $windowUI/infect_group/infectProgress
onready var infectNum = $windowUI/infect_group/infectProgress/infectNum
onready var infect_low = $windowUI/infect_group/infectlow
# attack UI load
onready var att_radial = $windowUI/attackProgres
onready var defend_radial = $windowUI/defendProgress
onready var turns = $windowUI/turns


var move = 0
var infect = 0
var attack = 0
var defend = 0
export var turn = 201
signal infect_amount

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_puzzle_move_update(move, infect, attack, defend)


func _on_puzzle_move_update(mover, infecter, attacker, defender):
	move += mover
	move_radial.progress = move
	moveNum.text = String(move)
	if move == 0:
		moveNum.visible = false
		uparrow.visible = false
		downarrow.visible = false
		rightarrow.visible = false
		leftarrow.visible = false
	else:
		uparrow.visible = true
		moveNum.visible = true
		downarrow.visible = true
		rightarrow.visible = true
		leftarrow.visible = true
	infect += infecter
	infect_radial.progress = infect
	infectNum.text = String(infect)
	if infect == 0:
		infectNum.visible = false
		infect_low.visible = false
	else:
		infectNum.visible = true
		infect_low.visible = true
	attack = attacker
	att_radial.progress = attack
	defend = defender
	defend_radial.progress = defend
	turn -= 1
	turns.text = String(turn)



func _on_player_move_remove():
	if move > 1:
		move -= 1
		move_radial.progress = move
		moveNum.text = String(move)
	else:
		move -= 1
		move_radial.progress = move
		moveNum.visible = false
		uparrow.visible = false
		downarrow.visible = false
		rightarrow.visible = false
		leftarrow.visible = false


func _on_player_infect_remove():
	if infect > 1:
		infect -= 1
		infect_radial.progress = infect
		infectNum.text = String(infect)
	else:
		infect -= 1
		infect_radial.progress = infect
		infectNum.visible = false
		infect_low.visible = false
	print(infect)
	emit_signal("infect_amount",infect)
