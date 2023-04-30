extends KinematicBody2D

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

export var detect_range: float = 200
export var SPEED: float = 100
export var FIRING_COOLDOWN_MAX: float = 1
var firing_cooldown: float = 0.5
var hitPoints: int = 3
var stunned: bool = false
var stunTime: float = 0

func _ready():
	player = get_node("/root/GameScene/Player")
	on_ground = get_node("OnGround")
	near_obstacle = get_node("NearObstacle")
	sprite = get_node("AnimatedSprite")
	towards_player = get_node("TowardsPlayer")
	hitPointsNode = get_node("LifePoints")
	hitPointsNode.lifePoints = hitPoints
	player.connect("stomp", self, "_stomp_occured")
	
func _physics_process(delta):
	if stunned:
		stunTime -= delta
		if stunTime <= 0:
			stunned = false
		return
	
	var space_state = get_world_2d().direct_space_state

	velocity.y += Global.GRAVITY * delta

	var playerInFront = sign((player.position - self.position).x) == direction

	if player.position.distance_to(self.position) < detect_range && playerInFront:
		towards_player.cast_to = player.position - self.position
		towards_player.enabled = true
		if towards_player.get_collider() == player:
			can_see_player = true
			firing_cooldown -= delta
			if sprite.animation != "firing":
				sprite.animation = "firing"
				sprite.frame = 0
				
			if firing_cooldown > FIRING_COOLDOWN_MAX / 4 * 3:
				sprite.frame = 1
			elif firing_cooldown > FIRING_COOLDOWN_MAX / 4 * 2:
				sprite.frame = 2
			else:
				sprite.frame = 4
	else: 
		towards_player.enabled = false
		can_see_player = false
		firing_cooldown = FIRING_COOLDOWN_MAX

	if (moving && near_obstacle.is_colliding()):
		moving = false
		velocity.x = 0
		sprite.animation = "default"
		
	if can_see_player:
		moving = false
		velocity.x = 0
		
		
	if !moving && on_ground.is_colliding() && !can_see_player:

		moving = true
		direction = -direction

	if direction > 0:
		if near_obstacle.cast_to.x != 25:
			near_obstacle.cast_to.x = 25
		if sprite.animation != "walk" && !can_see_player:
			sprite.animation = "walk"
		sprite.scale.x = -1
		
	elif direction < 0:
		if near_obstacle.cast_to.x != -25:
			near_obstacle.cast_to.x = -25
		if sprite.animation != "walk" && !can_see_player:
			sprite.animation = "walk"
		sprite.scale.x = 1
		
	if moving && !can_see_player:
		velocity.x = direction * SPEED

	velocity = move_and_slide(velocity, Vector2(0, -1))

func _process(delta):
	if stunned:
		if rand_range(1, 50) < 15:
			Global.make_spark_signal(position)
		return
		
	if firing_cooldown <= 0:
		var bullet = bolt.instance()
		Global.make_enemy_fire_signal()
		bullet.position = position
		bullet.targetVector = player.position - self.position
		get_parent().add_child(bullet)
		firing_cooldown = FIRING_COOLDOWN_MAX
		
	hitPointsNode.lifePoints = hitPoints
	if hitPoints <= 0:
		Global.make_explosion_signal(position + Vector2(8, 0))
		Global.make_explosion_signal(position + Vector2(-8, 0))
		Global.make_explosion_signal(position)
		queue_free()

func hit_by_star():
	if !can_see_player:
		direction = -direction
	detect_range *= 2
	FIRING_COOLDOWN_MAX = FIRING_COOLDOWN_MAX / 10 * 9
	hitPoints -= 1

func _stomp_occured(location: Vector2):
	var stompDistance = location.distance_to(position)

	if stompDistance < 100:
		stunned = true
		stunTime = 1
		hitPoints -=1
