extends RigidBody2D


var rand = RandomNumberGenerator.new()
var velocity
var direction = 1
var ball
var variant
var screen_position
var left_particles
var right_particles

# Called when the node enters the scene tree for the first time.
func _ready():
	ball = get_tree().get_root().get_node('variant/ball')
	variant = get_tree().get_root().get_node('variant')
	left_particles = get_tree().get_root().get_node('variant/left_score_particles')
	right_particles = get_tree().get_root().get_node('variant/right_score_particles')
	velocity = rand.randi_range(200, 600)
	screen_position = rand.randi_range(0, 1)
	if screen_position == 0:
		self.position.y = rand.randi_range(80, 250)
	else:
		self.position.y = rand.randi_range(350, 520)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.position.y > 530 or self.position.y < 70:
		direction *= -1
	self.position.y += delta * velocity * direction


func _on_Area2D_body_entered(body):
	variant.add_particles = true
	variant.particles_position_x = self.position.x
	variant.particles_position_y = self.position.y
	
	print('bonus collided with')
	if ball.linear_velocity.x > 0:
		variant.score1 += 1.0
		variant.soundManager.playLosePoint()
		left_particles.emitting = true
		left_particles.one_shot = true
	else:
		variant.score2 += 1.0
		variant.soundManager.playWinPoint()
		right_particles.emitting = true
		right_particles.one_shot = true
	variant.separator_block_added = false
	queue_free()
