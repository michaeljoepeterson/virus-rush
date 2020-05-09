extends Node2D

export (int) var enemyHealth = 4
onready var enemyBar = $enemyBattle/enemyHealth
var attack = false

signal battelWin
signal enemyAttack
signal playerAttack

func _ready():
	enemyBar.value = enemyHealth
	enemyBar.max_value = enemyHealth


func _on_player_battle(pos):
	position = pos
	self.visible = true


func _on_attackLow_button_down():
	enemyHealth -= 1
	enemyBar.value = enemyHealth
	get_node("attackTime").start()
	if enemyHealth == 0 :
		emit_signal("battelWin")
		self.visible = false
		enemyHealth = 4
		enemyBar.value = enemyHealth


func _process(delta):
	pass

func _on_attackTime_timeout():
	emit_signal("enemyAttack", 1)
