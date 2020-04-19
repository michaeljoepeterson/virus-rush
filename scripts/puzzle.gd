extends Node2D

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

var possible_blocks = [
	preload("res://scenes/move_block.tscn"),
	preload("res://scenes/attack_block.tscn"),
	preload("res://scenes/defend_block.tscn"),
	preload("res://scenes/infection_block.tscn")
]

var all_blocks = []

var first_touch = Vector2(0,0)
var last_touch = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	all_blocks = make_2d_array()
	spawn_block()

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array
	
func spawn_block():
	for i in width:
		for j in height:
			var rand = floor(rand_range(0,possible_blocks.size()))
			var block = possible_blocks[rand].instance()
			add_child(block)
			block.position = grid_to_pixel(i,j)


func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)
	
func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(abs(new_x), abs(new_y))

func touch_input():
	if Input.is_action_pressed("ui_touch"):
		first_touch = get_global_mouse_position()
		var grid_pos = pixel_to_grid(first_touch.x, first_touch.y)
		print(grid_pos)
		
func _process(delta):
	touch_input()
