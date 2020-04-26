extends Node2D

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var y_offset

var possible_blocks = [
	preload("res://scenes/move_block.tscn"),
	preload("res://scenes/attack_block.tscn"),
	preload("res://scenes/defend_block.tscn"),
	preload("res://scenes/infection_block.tscn")
]

var all_blocks = []

var first_touch = Vector2(0,0)
var blocker = preload("res://scenes/move_block.tscn")
var picked_blocks = []
var moveAmount = 0

signal move_update

# state machine
enum {wait, move}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = move
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
			all_blocks[i][j] = block

func match_at(i, j, color):
	if i > 1:
		if all_blocks[i - 1][j] != null && all_blocks[i][j - 1] != null:
			if all_blocks[i - 1][j].color == color && all_blocks[i][j - 1].color == color:
				return true
		if all_blocks[i - 1][j] != null && all_blocks[i - 2][j] != null:
			if all_blocks[i - 1][j].color == color && all_blocks[i - 2][j].color == color:
				return true
	if j > 1:
		if all_blocks[i][j - 1] != null && all_blocks[i - 1][j] != null:
			if all_blocks[i][j - 1].color == color && all_blocks[i - 1][j].color == color:
				return true
		if all_blocks[i][j - 1] != null && all_blocks[i][j - 2] != null:
			if all_blocks[i][j - 1].color == color && all_blocks[i][j - 2].color == color:
				return true

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(column, row):
	if column >= 0 && column < width:
		if row >= 0 && row < height:
			return true
	return false

func is_a_match(block):
	var no_match = true
	for i in picked_blocks:
		if block == i:
			no_match = false
	return no_match
	
#params = vector 2d
func handle_touch_down(grid_pos):
	if is_in_grid(grid_pos.x, grid_pos.y):
		if is_a_match(grid_pos):
			if all_blocks[grid_pos.x][grid_pos.y] != null:
				all_blocks[grid_pos.x][grid_pos.y].dim(0.5)
				picked_blocks.append(grid_pos)
#check if there is a match
func check_if_match():
	var no_match = false
	if picked_blocks.size() >= 3:
		for i in picked_blocks:
			#check initial color if that color is different for any picked blocks no match
			if all_blocks[picked_blocks[0].x][picked_blocks[0].y].color != all_blocks[i.x][i.y].color:
				no_match = true
				for m in width:
					for j in height: 
						if all_blocks[m][j] != null:
							all_blocks[m][j].dim(1)
	else:
		no_match = true
	return no_match

func handle_match():
	if all_blocks[picked_blocks[0].x][picked_blocks[0].y].color == "blue":
		emit_signal("move_update", picked_blocks.size(), 0, 0, 0)
		blocker = possible_blocks[0].instance()
		add_child(blocker)
		blocker.position = get_global_mouse_position()
		blocker.move_out(Vector2(90,80))
	if all_blocks[picked_blocks[0].x][picked_blocks[0].y].color == "green":
		emit_signal("move_update", 0, picked_blocks.size(), 0, 0)
		blocker = possible_blocks[3].instance()
		add_child(blocker)
		blocker.position = get_global_mouse_position()
		blocker.move_out(Vector2(500,80))
	if all_blocks[picked_blocks[0].x][picked_blocks[0].y].color == "red":
		emit_signal("move_update", 0, 0, picked_blocks.size(), 0)
		blocker = possible_blocks[1].instance()
		add_child(blocker)
		blocker.position = get_global_mouse_position()
		blocker.move_out(Vector2(90,500))
	if all_blocks[picked_blocks[0].x][picked_blocks[0].y].color == "yellow":
		emit_signal("move_update", 0, 0, 0, picked_blocks.size())
		blocker = possible_blocks[2].instance()
		add_child(blocker)
		blocker.position = get_global_mouse_position()
		blocker.move_out(Vector2(500,500))
	destroy_blocks()

func handle_touch_up():
	var no_match = self.check_if_match()
	if(no_match):
		picked_blocks = []
		for m in width:
			for j in height: 
				if all_blocks[m][j] != null:
					all_blocks[m][j].dim(1)
	else:
		self.handle_match()
	
#will need to emulate this function in test code
func touch_input():
	if Input.is_action_pressed("ui_touch"):
		first_touch = get_global_mouse_position()
		var grid_pos = pixel_to_grid(first_touch.x, first_touch.y)
		self.handle_touch_down(grid_pos)
	#doing it this way also cuts down one extra if check
	if Input.is_action_just_released("ui_touch"):
		self.handle_touch_up()

func _process(_delta):
	if state == move:
		touch_input()

func destroy_blocks():
	for i in picked_blocks:
		all_blocks[i.x][i.y].queue_free()
		all_blocks[i.x][i.y] = null
	picked_blocks = []
	get_parent().get_node("destroy_timer").start()

func destroy_all():
	for i in width:
		for j in height:
			if all_blocks[i][j] != null:
				all_blocks[i][j].queue_free()
				all_blocks[i][j] = null

func collapse_column():
	blocker.queue_free()
	for i in width:
		for j in height:
			if all_blocks[i][j] == null:
				for k in range(j + 1, height):
					if all_blocks[i][k] != null:
						all_blocks[i][k].move(grid_to_pixel(i, j))
						all_blocks[i][j] = all_blocks[i][k]
						all_blocks[i][k] = null
						break
	get_parent().get_node("refill_timer").start()

func refill_column():
	for i in width:
		for j in height:
			if all_blocks[i][j] == null:
				var rand = floor(rand_range(0,possible_blocks.size()))
				var block = possible_blocks[rand].instance()
				add_child(block)
				block.position = grid_to_pixel(i,j + y_offset)
				block.move(grid_to_pixel(i,j))
				all_blocks[i][j] = block
	test_for_moves()

func test_for_moves():
	var playOn = true
	for i in width:
		for j in height:
			if all_blocks[i][j] != null:
				if match_at(i, j, all_blocks[i][j].color):
					playOn = false
	if playOn:
		destroy_all()
		spawn_block()
	state = move

func _on_destroy_timer_timeout():
	collapse_column()

func _on_refill_timer_timeout():
	refill_column()
