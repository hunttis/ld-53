extends TextureRect

var camera: Camera2D

func _ready():
	camera = get_parent().get_parent().get_node("Camera2D")

func _process(delta):
	rect_position = camera.get_camera_screen_center() + Vector2(- 1280 / 2 / 2, - 800 / 2)
