extends Camera2D

var player: KinematicBody2D
var train: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	make_current()
	train = get_parent().get_node("Train")
	var train_area = train.get_used_rect()
	limit_left = train_area.position.x - 128
	limit_top = train_area.position.y
	limit_right = train_area.position.x + train_area.size.x * 16
	limit_bottom = 800
		
func _process(delta):
	position = player.position
