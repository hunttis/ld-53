extends RigidBody2D

var bolt = preload("res://assets/scenes/Bolt.tscn") 
var velocity = Vector2()
var on_ground: RayCast2D
var near_obstacle: RayCast2D
var towards_player: RayCast2D
var sprite: AnimatedSprite
var hitPointsNode: AnimatedSprite

var player: KinematicBody2D
var can_see_player = false

var moving = false
var direction = 1
var previousDirection = 0

var detect_range = 200
var firing_cooldown = 1
export var FIRING_COOLDOWN_MAX = 2
var hitPoints = 3
export var SPEED = 2
var stunTime = 0
var stunned = false

func _ready():
	player = get_node("/root/GameScene/Player")
	near_obstacle = get_node("NearObstacle")
	sprite = get_node("AnimatedSprite")
	towards_player = get_node("TowardsPlayer")
	hitPointsNode = get_node("LifePoints")
	hitPointsNode.lifePoints = hitPoints
	near_obstacle.enabled = true
	player.connect("stomp", self, "_stomp_occured")

func _physics_process(delta):
	if stunned:
		stunTime -= delta
		if stunTime <= 0:
			stunned = false
		return
	
	var playerInFront = sign((player.position - self.position).x) == direction

	if player.position.distance_to(self.position) < detect_range && playerInFront:
		towards_player.cast_to = player.position - self.position
		towards_player.enabled = true
		if towards_player.get_collider() == player:
			can_see_player = true
			firing_cooldown -= delta
	else:
		towards_player.enabled = false
		can_see_player = false
		firing_cooldown = FIRING_COOLDOWN_MAX

	if moving && near_obstacle.is_colliding():
		linear_velocity.x = 0
		sprite.animation = "default"
		direction = -direction

	if direction < 0:
		if near_obstacle.cast_to.x != -50:
			near_obstacle.cast_to.x = -50
		sprite.scale.x = 2
	elif direction > 0:
		if near_obstacle.cast_to.x != 50:
			near_obstacle.cast_to.x = 50
		sprite.scale.x = -2

	if can_see_player:
		moving = false
		linear_velocity.x = 0

	if moving && !can_see_player:
		sprite.speed_scale = abs(linear_velocity.x) / 20
		if abs(linear_velocity.x) < 100:
			apply_impulse(Vector2(0, 0), Vector2(direction * SPEED, 0))

	if !moving && !can_see_player: 
		moving = true
		
	if rotation > 0:
		rotation -= deg2rad(10)
		if rotation < 0:
			rotation = 0
	elif rotation < 0:
		rotation += deg2rad(10)
		if rotation > 0:
			rotation = 0

func _process(delta):
	if stunned:
		if rand_range(1, 50) < 15:
			Global.make_spark_signal(position)
		return

	if firing_cooldown > 0:
		firing_cooldown -= delta
	else:
		_fire()
		firing_cooldown = FIRING_COOLDOWN_MAX

	hitPointsNode.lifePoints = hitPoints
	
	if hitPoints <= 0:
		Global.make_explosion_signal(position)
		queue_free()

func _fire():
	var bullet = bolt.instance()
	Global.make_enemy_fire_signal()
	bullet.position = position
	bullet.targetVector = player.position - self.position
	get_parent().add_child(bullet)
	firing_cooldown = FIRING_COOLDOWN_MAX

func hit_by_star():
	hitPoints -= 1

func _stomp_occured(location: Vector2):
	var stompDistance = location.distance_to(position)
	
	if stompDistance < 100:
		apply_impulse(Vector2(0, 0), -(location - position).normalized() * 100)
		stunned = true
		stunTime = 1
		hitPoints -=1
