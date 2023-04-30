extends TextureRect

export(float) var scroll_speed = 0.4
var camera: Camera2D
var yOffset: float
var player: KinematicBody2D

func _ready():
	camera = get_parent().get_parent().get_node("Camera2D")
	player = get_parent().get_parent().get_node("Player")
	self.material.set_shader_param("scroll_speed", scroll_speed)
	yOffset = rect_position.y


func _process(delta):
	self.material.set_shader_param("scroll_speed", scroll_speed)
#	rect_position = camera.get_camera_screen_center() + Vector2(- 1280 / 2 / 2, 0)
	rect_position.y = yOffset
