extends Node2D

var stompStatus: Sprite
var doublejumpStatus: Sprite
var player: KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	stompStatus = get_node("StompStatus")
	doublejumpStatus = get_node("DoublejumpStatus")
	player = get_parent().get_parent().get_node("Player")

func _process(delta):
	if player.double_jumped:
		doublejumpStatus.modulate = Color(0.5, 0.5, 0.5)
	else:
		doublejumpStatus.modulate = Color(1, 1, 1)

	if !player.stomp_possible:
		stompStatus.modulate = Color(0.5, 0.5, 0.5)
	else:
		stompStatus.modulate = Color(1, 1, 1)
