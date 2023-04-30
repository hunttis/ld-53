extends Sprite

export var rotationSpeed: float = 1000

func _process(delta):
	rotation_degrees += rotationSpeed * delta
