extends AnimationPlayer

class_name SoundManager

var sounds: SoundResource = SoundResource.new()
onready var streamPlayer: NodePath = get_parent().get_path()

var bounceFile: Resource = preload("res://Music/Bounce.wav")
var bounceLength: float = bounceFile.get_length()
var bounceName: String = "Bounce"

var winPointFile: Resource = preload("res://Music/WinPoint.wav")
var winPointLength: float = winPointFile.get_length()
var winPointName: String = "WinPoint"

var losePointFile: Resource = preload("res://Music/LosePoint.wav")
var losePointLength: float = losePointFile.get_length()
var losePointName: String = "LosePoint"

var selectionFile: Resource = preload("res://Music/Selection.wav")
var selectionLength: float = selectionFile.get_length()
var selectionName: String = "Selection"

func _ready() -> void:
	self.name = "SoundManager"
	self.add_animation(bounceName, sounds.createSound(bounceFile, streamPlayer, bounceLength))
	self.add_animation(winPointName, sounds.createSound(winPointFile, streamPlayer, winPointLength))
	self.add_animation(losePointName, sounds.createSound(losePointFile, streamPlayer, losePointLength))
	self.add_animation(selectionName, sounds.createSound(selectionFile, streamPlayer, selectionLength))


func playBounce() -> void:
	self.play(bounceName)

func playWinPoint() -> void:
	self.play(winPointName)

func playLosePoint() -> void:
	self.play(losePointName)

func playSelection() -> void:
	self.play(selectionName)


"""
1 sfx file = 5 lines of code
"""
