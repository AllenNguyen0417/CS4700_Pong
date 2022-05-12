extends Node2D

var current_scene = null

# sound maker
var backgroundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var backgroundManager: BackgroundManager = BackgroundManager.new()

var soundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var soundManager: SoundManager = SoundManager.new()

onready var hud = $HUD
onready var menu = $MainMenu

var ball
var player
var computer
var player_score = 0
var computer_score = 0
var total_score = 0
var winning_score = 10
var ball_initial_velocity_x = 600
var ball_initial_velocity_y = 100
var computer_velocity_y = 300
var ball_direction = 0
var separator_block_added = false
var add_particles = false
var particles
var particles_position_x
var particles_position_y
var left_particles
var right_particles
var bonus_scene
var left_block
var right_block
var change_block_positions = true

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
	particles = get_node('particles')
	left_particles = get_node("left_score_particles")
	right_particles = get_node("right_score_particles")
	left_block = get_node("left_block")
	right_block = get_node("right_block")
	
	rand.randomize()
	set_block_positions()
	
	print('variant')


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
	
	# check if computer gets a point
	if ball.position.x > 1024:
		soundManager.playLosePoint()
		reset_position()
		self.score1 += 1.0
		left_particles.emitting = true
		left_particles.one_shot = true
		total_score += 1
		if total_score % 2 == 0 and change_block_positions == true:
			set_block_positions()
			change_block_positions = false
		elif total_score % 2 == 0 and change_block_positions == false:
			change_block_positions = true
		
	# check if the player gets a point
	if ball.position.x < 0:
		soundManager.playWinPoint()
		reset_position()
		self.score2 += 1.0
		right_particles.emitting = true
		right_particles.one_shot = true
		total_score += 1
		if total_score % 2 == 0 and change_block_positions == true:
			set_block_positions()
			change_block_positions = false
		elif total_score % 2 == 0 and change_block_positions == false:
			change_block_positions = true
		
	if self.score1 >= winning_score:
		# Remove the current level
		setScene('res://compWin.tscn')
	elif self.score2 >= winning_score:
		setScene('res://playerWin.tscn')
	
	# add bonus when one player is halfway to winning
	if separator_block_added == false and (self.score1 >= (winning_score / 2) or self.score2 >= (winning_score / 2)):
		bonus_scene = load('res://bonus.tscn')
		add_child(bonus_scene.instance())
		separator_block_added = true
		
	# add particle effect when ball collides with separator block
	if add_particles == true:
		particles.position.x = particles_position_x
		particles.position.y = particles_position_y
		particles.emitting = true
		particles.one_shot = true
		add_particles = false
		
	# speed up ball near end of game
	if self.score1 >= (winning_score / 2 + 2) or self.score2 >= (winning_score / 2 + 2):
		var ball_initial_velocity_x = 800


func reset_position():
	Physics2DServer.body_set_state(
		ball.get_rid(),
		Physics2DServer.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(Vector2(512, 300))
	)
	ball_direction = rand.randi_range(0, 1)
	if ball_direction == 0:
		ball.linear_velocity.x = ball_initial_velocity_x
		ball.linear_velocity.y = ball_initial_velocity_y
	else:
		ball.linear_velocity.x = -ball_initial_velocity_x
		ball.linear_velocity.y = -ball_initial_velocity_y

func set_block_positions():
	left_block.position.x = rand.randi_range(250, 450)
	left_block.position.y = rand.randi_range(75, 525)
	right_block.position.x = rand.randi_range(574, 774)
	right_block.position.y = rand.randi_range(75, 525)

func _on_Area2D_body_entered(body):
	soundManager.playBounce()
