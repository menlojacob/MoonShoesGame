extends AnimatedSprite2D

@onready var enemy = get_parent()
@onready var enemyController = enemy.get_node_or_null("EnemyController")

func _ready() -> void:
	enemyController.on_jumped_on.connect(func():
		#the enemy turns red for a second when you jump on it
		self.modulate = Color(1,0,0)
		await get_tree().create_timer(0.25).timeout
		self.modulate = Color(1,1,1)
	)
	
