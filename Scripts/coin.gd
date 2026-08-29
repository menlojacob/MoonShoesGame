extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal coin_collected
func _on_body_entered(body: Node2D) -> void:
	coin_collected.emit()
	animation_player.play("pickup")
