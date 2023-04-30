extends CPUParticles2D

func _ready():
	emitting = true
	for child in get_children():

		child.emitting = true

func _process(delta):
	if !emitting && get_child_count() == 0:
		queue_free()
