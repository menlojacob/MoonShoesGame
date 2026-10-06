extends Node

@onready var enemy = get_parent()
@onready var sprite = enemy.get_node_or_null("AnimatedSprite2D")

#enemy variables
@export var maxHealth = 1
@export var spikyHelmet = false

var health #becomes equal to maxhealth in _ready
var alive = true

var respawnTimer
var respawnCallable

signal on_jumped_on
signal died
signal respawned

func _ready():
	health = maxHealth #exported var only readable on _ready

func respawn():
	respawned.emit()
	
	alive = true
	health = maxHealth #reset health to max
	
	cancelRespawnTimer()
	
func cancelRespawnTimer():
	if respawnTimer and respawnCallable:
		respawnTimer.timeout.disconnect(respawnCallable)
		respawnTimer = null
		respawnCallable = null

func jumped_on():
	#reduce health
	health -= 1
	if health <= 0:
		alive = false
		died.emit()
		
		respawnTimer = get_tree().create_timer(5)
		respawnCallable = func():
			respawn()	
		respawnTimer.timeout.connect(respawnCallable)
	else:
		on_jumped_on.emit()

func is_alive():
	return alive;
