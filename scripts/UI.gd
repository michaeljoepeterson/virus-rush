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
onready var att_radial = $windowUI/attack_group/attackProgres
onready var attackLow = $windowUI/attack_group/attackLow
onready var defend_radial = $windowUI/defendProgress
onready var infection_percent = $windowUI/turns
var rng = RandomNumberGenerator.new()

var move = 0
var infect = 0
var attack = 3
var defend = 3
var ranout = true
var inBattle = false
export var turn = 201
signal infect_amount

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_puzzle_move_update(move, infect, attack, defend)
	moveNum.visible = false
	unhide_move(false)
	infectNum.visible = false
	infect_low.visible = false
	attackLow.visible = false

	
func unhide_move(hide):
	uparrow.visible = hide
	downarrow.visible = hide
	rightarrow.visible = hide
	leftarrow.visible = hide


func _on_puzzle_move_update(mover, infecter, attacker, defender):
	# ***********move**************
	if move + mover <= move_radial.max_value:
		move += mover
	elif move + mover > move_radial.max_value:
		move = move_radial.max_value
	move_radial.progress = move
	moveNum.text = String(move)
	if move > 0:
		moveNum.visible = true
		if !inBattle:
			unhide_move(true)
	#*************infect************
	if infect + infecter <= infect_radial.max_value:
		infect += infecter
	elif infect + infecter > infect_radial.max_value:
		infect = infect_radial.max_value
	infect_radial.progress = infect
	infectNum.text = String(infect)
	if infect > 0:
		infectNum.visible = true
		if ranout:
			if !inBattle:
				infect_low.visible = true
			else:
				infect_low.visible = false
			ranout = false
	#************attack***************
	if attacker > 0:
		if attacker > att_radial.max_value:
			attacker = att_radial.max_value
		attack = attacker
	att_radial.progress = attack
	if attack > 0:
		if inBattle:
			attackLow.visible = true
	#************defend***************
	if defender > 0:
		defend = defender
	defend_radial.progress = defend


func _on_player_move_remove():
	if move > 1:
		move -= 1
		move_radial.progress = move
		moveNum.text = String(move)
	else:
		move -= 1
		move_radial.progress = move
		moveNum.visible = false
		unhide_move(false)


func _on_infectlow_pressed():
	infect_low.visible = false


func _on_maze_infect_remove():
	if infect > 1:
		infect -= 1
		infect_radial.progress = infect
		infectNum.text = String(infect)
	else:
		infect -= 1
		infect_radial.progress = infect
		ranout = true
		infectNum.visible = false
		infect_low.visible = false
	emit_signal("infect_amount",infect)


func _on_maze_infect_percent(percent):
	infection_percent.text = String(percent) + " Infected"


func _on_player_battle_UI(display):
	unhide_move(!display)
	infect_low.visible = !display
	inBattle = display
	if attack > 0:
		attackLow.visible = display


func _on_battle_enemyAttack(attNum):
	defend = defend - attNum
	defend_radial.progress = defend
	if defend < 1:
		print (get_tree().change_scene("res://scenes/startScreen.tscn"))


func _on_battle_playerAttack():
	var x = rng.randi_range(3, attack)
	return x
