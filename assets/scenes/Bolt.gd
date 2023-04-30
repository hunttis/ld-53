extends RigidBody2D

var targetVector: Vector2
export var boltSpeed: float
var sprite: Sprite

func _ready():
	sprite = get_node("Sprite")

func _process(delta):
	linear_velocity = targetVector.normalized() * boltSpeed
	sprite.rotation = targetVector.angle()

func _on_Bolt_body_entered(body):
	if body.name == "Train":
		Global.make_explosion_signal(position)
		queue_free()
	if body.name == "Player":
		Global.player_hit_by_bolt()
		Global.make_explosion_signal(position)
		queue_free()
		
