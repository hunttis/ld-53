extends Area2D

export var unlocks_locks: int = 0

var player: KinematicBody2D
var sprite: AnimatedSprite

func _ready():
	player = get_node("/root/GameScene/Player")
	player.connect("stomp", self, "_stomp_occured")
	
	sprite = get_node("AnimatedSprite")
	if unlocks_locks == 0:
		print("SWITCH IS NOT ATTACHED TO LOCKS!")
	sprite.animation = "notpressed"

func _stomp_occured(location):
	var distanceFromStomp = location.distance_to(position)
	if distanceFromStomp < 20:
		sprite.animation = "pressed"
		Global.make_switch_signal(unlocks_locks)
		
