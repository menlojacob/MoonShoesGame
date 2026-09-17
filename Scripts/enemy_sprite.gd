extends AnimatedSprite2D

@onready var enemy = get_parent()
@onready var enemyController = enemy.get_node_or_null("EnemyController")

func _ready() -> void:
	enemyController.on_jumped_on.connect(playDamageAnimation)
	enemyController.died.connect(playDeathAnimation)
	enemyController.respawned.connect(onRespawn)

func playDamageAnimation():
	#the enemy turns red for a second when you jump on it
	self.modulate = Color(1,0,0)
	await get_tree().create_timer(0.25).timeout
	self.modulate = Color(1,1,1)

func playDeathAnimation():
	self.play("death")
	await self.animation_finished
	self.visible = false
	
func onRespawn():
	self.visible = true
	self.play("idle")
