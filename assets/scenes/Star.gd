extends RigidBody2D

var targetVector: Vector2
export var starSpeed: float
var sprite: Sprite

func _ready():
	sprite = get_node("Sprite")


func _process(delta):
	linear_velocity = targetVector.normalized() * starSpeed
	
func _on_Star_body_entered(body):
	if body.name == "Train":
		Global.make_spark_signal(position)
		Global.make_donk_signal()
		queue_free()
	if "Droid" in body.name || "Drone" in body.name:
		Global.make_explosion_signal(position)
		body.hit_by_star() 
		queue_free()
