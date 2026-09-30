extends Node2D

@export var speed = 2
@export var radius = 50

@onready var body = self.get_parent()
@onready var originalPosition = self.global_position

var rads = 0
	
func _physics_process(delta: float) -> void:
	rads += (speed * delta)
	var vectorAngle = Vector2(cos(rads),sin(rads))
	
	body.global_position = originalPosition + (vectorAngle * radius)
