extends Node

var done: bool = false
var win: bool = false
var moved: bool = false
var score: int = 0


# warning-ignore:unused_signal
signal GameOver()
# warning-ignore:unused_signal
signal TileMatch(amount)
