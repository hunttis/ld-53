extends CanvasLayer


var camera: Camera2D

func _ready():
	camera = get_parent().get_node("Camera2D")

