extends Node

export var GRAVITY = 300
var playerWon = false

signal explosion(location)
signal player_hit_by_bolt()
signal collectible(location)
signal spark(location)
signal switch_pressed(switch_number)
signal fireworks(location)
signal game_over()
signal enemy_fire()
signal donk()

func make_explosion_signal(location):
	emit_signal("explosion", location)

func player_hit_by_bolt():
	emit_signal("player_hit_by_bolt")

func make_collectible_signal(location):
	emit_signal("collectible", location)

func make_spark_signal(location):
	emit_signal("spark", location)

func make_switch_signal(switch_number):
	emit_signal("switch_pressed", switch_number)
	
func make_fireworks_signal(location):
	emit_signal("fireworks", location)
	
func make_gameover_signal():
	emit_signal("game_over")
	
func make_enemy_fire_signal():
	emit_signal("enemy_fire")
	
func make_donk_signal():
	emit_signal("donk")

func _process(delta):
	if playerWon:
		if rand_range(1, 100) < 5:
			make_fireworks_signal(Vector2(rand_range(0, 1280), rand_range(0, 800)))
