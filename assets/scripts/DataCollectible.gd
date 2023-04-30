extends RigidBody2D

func _on_DataCollectible_body_entered(body):
	if body.name == "Player":
		Global.make_collectible_signal(position)
		queue_free()
