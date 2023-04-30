extends KinematicBody2D

var star = preload("res://assets/scenes/Star.tscn") 

var velocity = Vector2()
var on_ground: RayCast2D
var on_ground2: RayCast2D
var stompRay: RayCast2D
var wallGrabRay: RayCast2D
var sprite: AnimatedSprite
var double_jumped: bool = false
var stomp_possible: bool = false
var stomping: bool = false
var grabbing: bool = false
var hitPoints: int = 3
var throw_cooldown: float = 0
var hitPointsNode: AnimatedSprite
var game_over = false
var stunned = false
var stunTime: float = 0

export var SPEED = 150
export var JUMP_STRENGTH = 300
export var THROW_COOLDOWN_MAX = 0.5

signal jump(location)
signal stomp(location)
signal dive(location)

func _ready():
	on_ground = get_node("OnGround")
	on_ground2 = get_node("OnGround2")
	stompRay = get_node("StompRay")
	wallGrabRay = get_node("WallGrabRay")
	sprite = get_node("AnimatedSprite")
	Global.connect("player_hit_by_bolt", self, "_hit_by_bolt")
	Global.connect("collectible", self, "_on_collectible")
	hitPointsNode = get_parent().get_node("UI/StatusIcons/LifePoints")
	hitPointsNode.lifePoints = 3

func _physics_process(delta):
	if stunned:
		stunTime -= delta
		if stunTime <= 0:
			stunned = false
		else:
			print(velocity.y)
			velocity.y += Global.GRAVITY * delta
			velocity = move_and_slide(velocity, Vector2(0, -1))

		return
		
	if hitPoints <= 0:
		return
		
	var onFloor = on_ground.is_colliding() || on_ground2.is_colliding()
	
	if onFloor:
		stompRay.enabled = false
		wallGrabRay.enabled = false
	else:
		stompRay.enabled = true
		wallGrabRay.enabled = true
	
	if grabbing && !wallGrabRay.is_colliding():
		grabbing = false

	if Input.is_action_pressed("ui_left"):
		if wallGrabRay.is_colliding():
			grabbing = true
			double_jumped = false
		if stomping:
			velocity.x = -SPEED / 3
		else:
			velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		if wallGrabRay.is_colliding():
			grabbing = true
			double_jumped = false
		if stomping:
			velocity.x = SPEED / 3
		else:
			velocity.x = SPEED
	else:
		grabbing = false
		velocity.x = 0

	if Input.is_action_just_pressed("ui_up") && onFloor:
		velocity.y = -JUMP_STRENGTH
		emit_signal("jump", position)
	elif grabbing && Input.is_action_just_pressed("ui_up"):
		stunned = true
		stunTime = 0.2
		velocity.y = -JUMP_STRENGTH
	elif Input.is_action_just_pressed("ui_up") && !onFloor && !double_jumped:
		double_jumped = true
		velocity.y = -JUMP_STRENGTH
		emit_signal("jump", position)

	if double_jumped && onFloor:
		double_jumped = false

	if stomping && onFloor:
		print("ka-STOMP")
		emit_signal("stomp", position)
		stomping = false

	if !stomping &&  !onFloor && !stompRay.is_colliding():
		stomp_possible = true
	else:
		stomp_possible = false

	if stomp_possible && Input.is_action_pressed("ui_down"):
		print("Starting to stomp!")
		emit_signal("dive", position)
		stomping = true

	if stomping:
		velocity.y += Global.GRAVITY * delta * 10
	elif grabbing && !stunned:
		velocity.y = 0
	else:
		velocity.y += Global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _process(delta):
	hitPointsNode.lifePoints = hitPoints
	
	if hitPoints <= 0:
		if !game_over:
			Global.make_gameover_signal()
			game_over = true
		return
	
	var onFloor = on_ground.is_colliding() || on_ground2.is_colliding()
		
	if throw_cooldown > 0:
		throw_cooldown -= delta
	if throw_cooldown <= 0 && Input.is_action_just_pressed("ui_accept"):
		print("FIRE!")
		throw_cooldown = THROW_COOLDOWN_MAX
		var throwing_star = star.instance()
		throwing_star.position = position
		var throw_direction = Vector2(sprite.scale.x, 0)
		if Input.is_action_pressed("ui_down"):
			throw_direction += Vector2(0, 0.8)
		elif Input.is_action_pressed("ui_up"):
			throw_direction += Vector2(0, -0.8)

		throwing_star.targetVector = throw_direction.normalized()
		get_parent().add_child(throwing_star)
	
	if velocity.x > 0:
		if wallGrabRay.cast_to.x != 10:
			wallGrabRay.cast_to.x = 10
		if sprite.animation != "walk" && onFloor:
			sprite.animation = "walk"
		elif !onFloor:
			sprite.animation = "jump"
		sprite.scale.x = 1
	elif velocity.x < 0:
		if wallGrabRay.cast_to.x != -10:
			wallGrabRay.cast_to.x = -10
		if sprite.animation != "walk" && onFloor:
			sprite.animation = "walk"
		elif !onFloor:
			sprite.animation = "jump"
		sprite.scale.x = -1
	else:
		if grabbing:
			sprite.animation = "grab"
		elif velocity.y != 0:
			sprite.animation = "jump"

	if velocity.y == 0 && velocity.x == 0 && !grabbing:
		sprite.animation = "default"

func _hit_by_bolt():
	hitPoints -= 1

func hit_by_spikes():
	Global.make_spark_signal(position + Vector2(0, 16))
	velocity.y = -JUMP_STRENGTH
	hitPoints -= 1

func _on_collectible(location):
	hitPoints = 3
