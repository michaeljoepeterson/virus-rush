extends "res://addons/gut/test.gd"
#get puzzle class
const Puzzle = preload("res://scripts/puzzle.gd")
const MoveBlock = preload("res://scenes/move_block.tscn")
const AttackBlock =	preload("res://scenes/attack_block.tscn")
const DefendBlock =	preload("res://scenes/defend_block.tscn")
const InfectionBlock = preload("res://scenes/infection_block.tscn")

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

func before_each():
	#gut.p("ran setup")
	pass

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
	var puzzle = Puzzle.new()
	
	#set height and width
	puzzle.height = self.puzzleHeight
	puzzle.width = self.puzzleWidth
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
	puzzle.height = self.puzzleHeight
	puzzle.width = self.puzzleWidth
	puzzle.all_blocks = puzzle.make_2d_array()
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
func test_touch_method():
	
	assert_eq('asdf', 'asdf', "Should pass")

# func test_assert_true_with_true():
# 	assert_true(true, "Should pass, true is true")

# func test_assert_true_with_false():
# 	assert_true(false, "Should fail")

# func test_something_else():
# 	assert_true(false, "didn't work")
