
extends Area2D
class_name Killzone

@onready var timer = $Timer
signal respawn

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	Engine.time_scale = 0.5
	timer.start()
	body.get_node("CollisionShape2D").disabled = true

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	respawn.emit()
