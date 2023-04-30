extends Node2D

var puffFx = preload("res://assets/scenes/PuffFx.tscn") 
var diveFx = preload("res://assets/scenes/DiveFx.tscn") 
var stompFx = preload("res://assets/scenes/StompFx.tscn") 
var explosionFx = preload("res://assets/scenes/ExplosionFx.tscn") 
var collectibleFx = preload("res://assets/scenes/CollectFx.tscn") 
var sparkFx = preload("res://assets/scenes/SparkFx.tscn") 
var fireworksFx = preload("res://assets/scenes/FireworksFx.tscn") 
var player: KinematicBody2D
var UINode: CanvasLayer

var boomSound: AudioStreamPlayer
var collectSound: AudioStreamPlayer
var crunchSound: AudioStreamPlayer
var exploSound: AudioStreamPlayer
var hurtSound: AudioStreamPlayer
var jumpSound: AudioStreamPlayer
var loseSound: AudioStreamPlayer
var blorpSound: AudioStreamPlayer
var enemyhurtSound: AudioStreamPlayer
var donkSound: AudioStreamPlayer

func _ready():
	UINode = get_parent().get_node("UI")
	player = get_parent().get_node("Player")
	player.connect("jump", self, "_on_jump")
	player.connect("stomp", self, "_on_stomp")
	player.connect("dive", self, "_on_dive")
	Global.connect("explosion", self, "_on_explosion")
	Global.connect("collectible", self, "_on_collectible")
	Global.connect("spark", self, "_on_spark")
	Global.connect("fireworks", self, "_on_fireworks")
	Global.connect("player_hit_by_bolt", self, "_on_hurt")
	Global.connect("enemy_fire", self, "_on_enemy_fire")
	Global.connect("enemy_hurt", self, "_on_enemy_hurt")
	Global.connect("donk", self, "_on_donk")
	
	boomSound = get_parent().get_node("Sounds/BoomSound")
	collectSound = get_parent().get_node("Sounds/CollectSound")
	crunchSound = get_parent().get_node("Sounds/CrunchSound")
	exploSound = get_parent().get_node("Sounds/ExploSound")
	hurtSound = get_parent().get_node("Sounds/HurtSound")
	jumpSound = get_parent().get_node("Sounds/JumpSound")
	loseSound = get_parent().get_node("Sounds/LoseSound")
	blorpSound = get_parent().get_node("Sounds/BlorpSound")
	enemyhurtSound = get_parent().get_node("Sounds/EnemyHurtSound")
	donkSound = get_parent().get_node("Sounds/DonkSound")
	
func _on_jump(location: Vector2):
	var fx = puffFx.instance()
	fx.position = location
	fx.emitting = true
	jumpSound.pitch_scale = rand_range(1, 1.2)
	jumpSound.play()
	get_parent().add_child(fx)

func _on_stomp(location: Vector2):
	var fx = stompFx.instance()
	fx.position = location + Vector2(0, 16)
	fx.emitting = true
	boomSound.play()
	get_parent().add_child(fx)

func _on_dive(location: Vector2):
	var fx = diveFx.instance()
	fx.position = location + Vector2(0, -16)
	fx.emitting = true
	get_parent().add_child(fx)

func _on_explosion(location: Vector2):
	var fx = explosionFx.instance()
	fx.position = location + Vector2(0, 0)
	exploSound.play()
	get_parent().add_child(fx)

func _on_collectible(location: Vector2):
	var fx = collectibleFx.instance()
	fx.position = location
	fx.emitting = true
	collectSound.play()
	get_parent().add_child(fx)

func _on_spark(location: Vector2):
	var fx = sparkFx.instance()
	fx.position = location
	fx.emitting = true
	get_parent().add_child(fx)
	
func _on_fireworks(location: Vector2):
	var fx = fireworksFx.instance()
	fx.position = location + Vector2(0, 0)
	exploSound.play()
	UINode.add_child(fx)

func _on_hurt():
	hurtSound.play()

func _on_enemy_fire():
	blorpSound.play()

func _on_enemy_hurt():
	enemyhurtSound.play()

func _on_donk():
	donkSound.pitch_scale = rand_range(1, 1.2)
	donkSound.play()
