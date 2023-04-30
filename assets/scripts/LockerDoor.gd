extends StaticBody2D

export var attached_to_switch: int = 0

func _ready():
	if attached_to_switch == 0:
		print("LOCK IS NOT ATTACHED TO SWITCH!")
	Global.connect("switch_pressed", self, "_on_switch_pressed")

func _on_switch_pressed(switch_number):
	if switch_number == attached_to_switch:

		Global.make_explosion_signal(position)
		queue_free()
