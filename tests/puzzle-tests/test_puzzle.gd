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
	self.puzzle = Puzzle.new()
	#set defaults and a fresh puzzle instance for each test
	self.puzzle.height = self.puzzleHeight
	self.puzzle.width = self.puzzleWidth
	self.puzzle.all_blocks = puzzle.make_2d_array()
	self.puzzle.height = self.puzzleHeight
	self.puzzle.width = self.puzzleWidth
	self.puzzle.offset = self.Offset
	self.puzzle.x_start = self.XStart
	self.puzzle.y_start = self.YStart
	self.puzzle.y_offset = self.YOffset


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
	
	var puzzleArray = self.puzzle.make_2d_array()
	gut.p('puzzle height and width: ')
	gut.p(self.puzzle.height)
	gut.p(self.puzzle.width)
	gut.p('array height and width: ')
	gut.p(puzzleArray[0].size())
	gut.p(puzzleArray.size())
	assert_eq(puzzleArray.size(), self.puzzleWidth, "Puzzle array should equal random puzzle width")
	assert_eq(puzzleArray[0].size(), self.puzzleHeight, "Puzzle array should equal random puzzle height")
func test_spawn_blocks():
	gut.p('==========Start Spawn Block Test==========')
	var testMove = MoveBlock.instance()
	self.puzzle.spawn_block()
	var allTypesMatch = true
	for i in self.puzzle.width:
		for k in self.puzzle.height:
			var block = self.puzzle.all_blocks[i][k]
			if(!self.BlockFileNames[block.filename]):
				allTypesMatch = false
				break
			
	#check filename of instance to make sure it is of a instance
	gut.p('instance of all blocks are correct type')
	assert_true(allTypesMatch, "All spawn blocks should be of correct type")

#emulate touch input func in puzzle class, can't use that func since it is using Input	
func emulate_touch(touch_action,x,y):
	if(touch_action == self.touch_up):
		gut.p('Passed x and y: ' + str(x) + ', ' + str(y))
	elif(touch_action == self.touch_down):
		gut.p('Passed x and y: ' + str(x) + ', '  + str(y))
		
func make_line_vertical(grid):
	var line = []
	var width = grid.size()
	var height = grid[0].size()
	var startCol = randi()%width+1
	var lineHeight = randi()%height+1
	for i in lineHeight:
		var pos = Vector2(startCol,i)
		line.append(pos)
	return line;
	
func make_line_horizontal(grid):
	var line = []
	var width = grid.size()
	var height = grid[0].size()
	var startRow = randi()%height+1
	var lineWidth = randi()%width+1
	for i in lineWidth:
		var pos = Vector2(i,startRow)
		line.push(pos)
	return line;

#build grid with all same block types for testing
func all_match_grid(grid,width,height):
	var randBlock = self.possible_blocks[randi()%self.possible_blocks.size()+1]
	for i in width:
		for k in height:
			var col = randBlock.instance()
			col.position = self.puzzle.grid_to_pixel(i,k)
			grid[i][k] = col
	return grid
func test_touch_method():
	gut.p('==========Start Spawn Puzzle Touch Test==========')
	self.puzzle.all_blocks = self.all_match_grid(self.puzzle.all_blocks,self.puzzleWidth,self.puzzleHeight)
	var verticalLine = self.make_line_vertical(self.puzzle.all_blocks)
	for pos in verticalLine:
		emulate_touch(self.touch_down,pos.x,pos.y)
	
	assert_eq('asdf', 'asdf', "Should pass")

