extends "res://addons/gut/test.gd"
#get puzzle class
const Puzzle = preload("res://scripts/puzzle.gd")

const MoveBlock = preload("res://scenes/move_block.tscn")
const AttackBlock =	preload("res://scenes/attack_block.tscn")
const DefendBlock =	preload("res://scenes/defend_block.tscn")
const InfectionBlock = preload("res://scenes/infection_block.tscn")

var possible_blocks = [
	preload("res://scenes/move_block.tscn"),
	preload("res://scenes/attack_block.tscn"),
	preload("res://scenes/defend_block.tscn"),
	preload("res://scenes/infection_block.tscn")
]

const BlockFileNames = {
	"res://scenes/move_block.tscn":"res://scenes/move_block.tscn",
	"res://scenes/attack_block.tscn":"res://scenes/attack_block.tscn",
	"res://scenes/defend_block.tscn":"res://scenes/defend_block.tscn",
	"res://scenes/infection_block.tscn":"res://scenes/infection_block.tscn"
}

#random puzzle height width between 1 - 50
#keep it like this so that ints are compared and not floats
var puzzleHeight = randi()%501+1
var puzzleWidth = randi()%501+1
var touch_down = "touch_down";
var touch_up = "touch_up";

var Offset = 64
var XStart = 64
var YStart = 900
var YOffset = 2
var puzzle;
func before_each():
	puzzle = Puzzle.new()
	#set defaults and a fresh puzzle instance for each test
	puzzle.height = self.puzzleHeight
	puzzle.width = self.puzzleWidth
	puzzle.all_blocks = puzzle.make_2d_array()
	puzzle.height = self.puzzleHeight
	puzzle.width = self.puzzleWidth
	puzzle.offset = self.Offset
	puzzle.x_start = self.XStart
	puzzle.y_start = self.YStart
	puzzle.y_offset = self.YOffset


func after_each():
	#gut.p("==========ran teardown==========")
	pass

func before_all():
	
	#gut.p("==========ran run setup==========")
	pass

func after_all():
	#gut.p("==========ran run teardown==========")
	pass

func test_array_created():
	gut.p('==========Start Puzzle Array Create Test==========')
	
	var puzzleArray = puzzle.make_2d_array()
	gut.p('puzzle height and width: ')
	gut.p(puzzle.height)
	gut.p(puzzle.width)
	gut.p('array height and width: ')
	gut.p(puzzleArray[0].size())
	gut.p(puzzleArray.size())
	assert_eq(puzzleArray.size(), self.puzzleWidth, "Puzzle array should equal random puzzle width")
	assert_eq(puzzleArray[0].size(), self.puzzleHeight, "Puzzle array should equal random puzzle height")
func test_spawn_blocks():
	gut.p('==========Start Spawn Block Test==========')
	var puzzle = Puzzle.new()
	var testMove = MoveBlock.instance()
	puzzle.spawn_block()
	var allTypesMatch = true
	for i in puzzle.width:
		for k in puzzle.height:
			var block = puzzle.all_blocks[i][k]
			if(!self.BlockFileNames[block.filename]):
				allTypesMatch = false
				break
			
	#check filename of instance to make sure it is of a instance
	gut.p('instance of all blocks are correct type')
	assert_true(allTypesMatch, "All spawn blocks should be of correct type")

#emulate touch input func in puzzle class, can't use that func since it is using Input	
func emulate_touch(touch_action,puzzle,x,y):
	if(touch_action == self.touch_up):
		var grid_pos = puzzle.pixel_to_grid(x,y)
		gut.p('')
	elif(touch_action == self.touch_down):
		gut.p('')
#build grid with all same block types for testing
func all_match_grid(grid,width,height,puzzle):
	var randBlock = self.possible_blocks[randi()%self.possible_blocks.size()+1]
	for i in width:
		for k in height:
			var col = randBlock.instance()
			col.position = puzzle.grid_to_pixel(i,k)
			grid[i][k] = col
		
func test_touch_method():
	gut.p('==========Start Spawn Puzzle Touch Test==========')
	var puzzle = Puzzle.new()
	
	assert_eq('asdf', 'asdf', "Should pass")

# func test_assert_true_with_true():
# 	assert_true(true, "Should pass, true is true")

# func test_assert_true_with_false():
# 	assert_true(false, "Should fail")

# func test_something_else():
# 	assert_true(false, "didn't work")
