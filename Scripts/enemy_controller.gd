extends Node

@onready var enemy = get_parent()
@onready var sprite = enemy.get_node_or_null("AnimatedSprite2D")

#enemy variables
@export var maxHealth = 1
@export var spikyHelmet = false

var health #becomes equal to maxhealth in _ready
var alive = true

signal on_jumped_on
signal died
signal respawned

func _ready():
	health = maxHealth #exported var only readable on _ready

func respawn():
	alive = true
	health = maxHealth #reset health to max
	
	respawned.emit()

func jumped_on():
	#reduce health
	health -= 1
	if health <= 0:
		alive = false
		died.emit()
		
		get_tree().create_timer(3).timeout.connect(func():
			if not alive:
				respawn()	
		)
	else:
		on_jumped_on.emit()

func is_alive():
	return alive;
