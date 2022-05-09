extends Node2D

var current_scene = null

# sound maker
var backgroundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var backgroundManager: BackgroundManager = BackgroundManager.new()

var soundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var soundManager: SoundManager = SoundManager.new()

onready var hud = $HUD
onready var menu = $MainMenu
# Declare member variables here.
var ball
var player
var computer
var bonus
var player_score = 0
var computer_score = 0
var winning_score = 5
var initial_velocity_x = 600
var initial_velocity_y = 100
var computer_velocity_y = 300
var bonus_added = false
var ball_direction = 0

var rand = RandomNumberGenerator.new()

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
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	
	backgroundStream.name = "BackgroundStream"
	backgroundStream.add_child(backgroundManager)
	add_child(backgroundStream)
	
	soundStream.name = "SoundStream"
	soundStream.add_child(soundManager)
	add_child(soundStream)
	
	player = get_node('player') 
	computer = get_node('computer')
	ball = get_node('ball')
	print('variant')
	
	rand.randomize()
	
	connect('body_entered', bonus, 'on_bonus_body_entered')

func setScene(scene):
	current_scene.queue_free()
	var s = ResourceLoader.load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)

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
	
	
	if ball.position.x < 80 or ball.position.x > 944:
		soundManager.playBounce()
	
	if ball.position.x > 1024:
		soundManager.playLosePoint()
		reset_position()		
		self.score1 += 0.25
		
	if ball.position.x < 0:
		soundManager.playWinPoint()
		reset_position()
		self.score2 += 0.25
	
	# add bonus when one player is halfway to winning
	if (bonus_added == false) and ((self.score1 >= winning_score / 2) or (self.score2 >= winning_score / 2)):
		bonus_added = true
		bonus = get_node('bonus')
		bonus.visible = true
		bonus.position.x = 512
		bonus.position.y = rand.randi_range(50, 462)
		print('bonus added')
		print(bonus.position.y)
		
	if self.score1 >= winning_score:	
		# Remove the current level
		setScene('res://compWin.tscn')
	elif self.score2 >= winning_score:
		setScene('res://playerWin.tscn')
		
	
func reset_position():
	Physics2DServer.body_set_state(
		ball.get_rid(),
		Physics2DServer.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(Vector2(512, 300))
	)
	ball_direction = rand.randi_range(0, 1)
	if ball_direction == 0:
		ball.linear_velocity.x = initial_velocity_x
		ball.linear_velocity.y = initial_velocity_y	
	else:
		ball.linear_velocity.x = -initial_velocity_x
		ball.linear_velocity.y = -initial_velocity_y	
	
func on_bonus_body_entered():
	print('bonus collided with')
	if ball.linear_velocity.x > 0:
		self.score1 += 1.0
	else:
		self.score2 += 1.0
	remove_child(bonus)
