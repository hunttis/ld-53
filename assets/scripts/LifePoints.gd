extends AnimatedSprite

export var showOnlyWhenDamaged: bool = true

export var lifePoints: int = 3

func _process(delta):
	if showOnlyWhenDamaged && lifePoints == 3:
		visible = false
	elif !visible:
		visible = true
	
	if frame != 3 - lifePoints:
		frame = 3 - lifePoints
