extends Node2D

onready var hud = $HUD
onready var menu = $MainMenu
# Declare member variables here.
var ball
var player
var computer
var player_score = 0
var computer_score = 0
var winning_score = 5
var initial_velocity_x = 600
var initial_velocity_y = 100
var computer_velocity_y = 300

var score1 = 0 setget set_score1
var score2 = 0 setget set_score2

func set_score1(new_score1):
	score1 = new_score1
	hud.update_score1(score1)

func set_score2(new_score2):
	score2 = new_score2
	hud.update_score2(score2)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node('player')
	computer = get_node('computer')
	ball = get_node('ball')
	print('clone')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.position.y = get_viewport().get_mouse_position().y
	if ball.position.y > computer.position.y:
		# move computer down
		computer.position.y += delta * computer_velocity_y
	elif ball.position.y < computer.position.y:
		# move computer up
		computer.position.y -= delta * computer_velocity_y
		
	if ball.linear_velocity.x > 0 and ball.linear_velocity.x < 400:
		ball.linear_velocity.x = 600
	if ball.linear_velocity.x < 0 and ball.linear_velocity.x > -400:
		ball.linear_velocity.x = -600
	
	if ball.position.x > 1024:
		reset_position()		
		self.score1 += 1.0
		
	if ball.position.x < 0:
		reset_position()
		self.score2 += 1.0		
		
	if self.score1 >= winning_score or self.score2 >= winning_score:
		self.score1 = 0
		self.score2 = 0
	
func reset_position():
	Physics2DServer.body_set_state(
		ball.get_rid(),
		Physics2DServer.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(Vector2(512, 300))
	)
	ball.linear_velocity.x = initial_velocity_x
	ball.linear_velocity.y = initial_velocity_y
