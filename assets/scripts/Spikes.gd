extends Area2D

func _on_Spikes_body_entered(body):
	if body.name == "Player":
		body.hit_by_spikes()
