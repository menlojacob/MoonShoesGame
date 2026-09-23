extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _on_enemy_controller_on_jumped_on() -> void:
	#this enemy turns red for a second when you jump on it
	sprite.modulate = Color(1,0,0)
	await get_tree().create_timer(0.25).timeout
	sprite.modulate = Color(1,1,1)

func _on_enemy_controller_died() -> void:
	sprite.play("death")
	await sprite.animation_finished
	sprite.hide()

func _on_enemy_controller_respawned() -> void:
	sprite.show()
	sprite.play("idle")
