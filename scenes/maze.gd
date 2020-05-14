extends Node2D


const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

var tile_size = 128  # tile size (in pixels)
var width = 20  # width of map (in tiles)
var height = 12  # height of map (in tiles)

# get a reference to the map for convenience
onready var Map = $lungmap
onready var infectMap = $infectMap
onready var enemy = preload("res://scenes/badguy.tscn")

signal infect_remove
signal infect_percent

var rng = RandomNumberGenerator.new()
var infect_count = 0
var stack = []

func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()
	make_enemies()
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		


func _on_player_infect_block(infect_block):
	var replace_tile = Map.get_cellv(infect_block)
	if infectMap.get_cellv(infect_block) == -1:
		infect_count += 1
		infectMap.set_cellv(infect_block, replace_tile)
		emit_signal("infect_remove")
		emit_signal("infect_percent", infect_count)


func make_enemies():
	rng.randomize()
	for _i in range(0,10):
		var badguy = enemy.instance()
		var x = rng.randi_range(2, width)
		var y = rng.randi_range(2, height)
		print(Vector2(x,y))
		x = (x * 128) + 64
		y = (y * 128) + 64
		badguy.position = Vector2(x,y)
		add_child(badguy)
		
func make_end():
	pass
