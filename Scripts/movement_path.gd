extends Node

var positions = []

@onready var body = self.get_parent()

@export var speed = 50

func _ready():
	#get movement positions - defined as Node2ds
	for child in self.get_children():
		if child.is_class("Node2D"):
			var position = child.global_position
			positions.push_back(position) #insert position into the array
	
	while true:
		for position in positions:
			var tween = tweenToPosition(position)
			await tween.finished

func tweenToPosition(nextPosition):
	var distance = body.global_position.distance_to(nextPosition)
	var time = distance/speed #physics 101
	
	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(body, "global_position", nextPosition, time)
	
	return tween
