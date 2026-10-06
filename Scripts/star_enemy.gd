extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var enemy_controller: Node = $EnemyController

func _on_enemy_controller_on_jumped_on() -> void:
	#this enemy turns red for a second when you jump on it
	sprite.modulate = Color(1,0,0)
	await get_tree().create_timer(0.25).timeout
	sprite.modulate = Color(1,1,1)

func _on_enemy_controller_respawned() -> void:
	sprite.show()
	if(!enemy_controller.is_alive()):
		sprite.play("respawn")
		await sprite.animation_finished
	sprite.play("idle")

func _on_enemy_controller_died() -> void:
	sprite.play("death")
	await sprite.animation_finished
	sprite.hide()
