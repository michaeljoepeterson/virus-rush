extends "res://addons/gut/test.gd"
#get puzzle class
const Puzzle = preload("res://scripts/puzzle.gd")
#random puzzle height width between 1 - 50
var puzzleHeight = randi()%51+1
var puzzleWidth = randi()%51+1

func before_each():
	gut.p("ran setup")

func after_each():
	gut.p("==========ran teardown==========")

func before_all():
	gut.p("==========ran run setup==========")

func after_all():
	gut.p("==========ran run teardown==========")

func test_array_created():
	var puzzle = Puzzle.new()
	
	#set height and width
	puzzle.height = self.puzzleHeight
	puzzle.width = self.puzzleWidth
	var puzzleArray = puzzle.make_2d_array()
	gut.p('puzzle height and width')
	gut.p(puzzle.height)
	gut.p(puzzle.width)
	assert_eq(puzzleArray.size(), self.puzzleWidth, "Puzzle array should equal random puzzle width")
	assert_eq(puzzleArray[0].size(), self.puzzleHeight, "Puzzle array should equal random puzzle height")

# func test_assert_eq_number_equal():
# 	assert_eq('asdf', 'asdf', "Should pass")

# func test_assert_true_with_true():
# 	assert_true(true, "Should pass, true is true")

# func test_assert_true_with_false():
# 	assert_true(false, "Should fail")

# func test_something_else():
# 	assert_true(false, "didn't work")
