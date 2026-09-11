extends Node

@onready var enemy = get_parent()
@onready var sprite = enemy.get_node_or_null("Sprite2D")

signal on_jumped_on

func jumped_on():
	on_jumped_on.emit()
