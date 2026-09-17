extends Node

var positions = []

@onready var body = self.get_parent()
@onready var enemyController = body.get_node_or_null("EnemyController")
@onready var initialPosition = body.global_position

@export var speed = 50

var activeTween

func _ready():
	#get movement positions - defined as Node2ds
	for child in self.get_children():
		if child.is_class("Node2D"):
			var position = child.global_position
			positions.push_back(position) #insert position into the array
	
	#connect to died signal
	if enemyController:
		enemyController.died.connect(func():
			cancelCurrentTween()
		)
	
	#connect to respawned signal
	enemyController.respawned.connect(func():
		startMovement()
	)
	
	startMovement()

func tweenToPositionIndex(index):
	var nextPosition = positions[index]
	var distance = body.global_position.distance_to(nextPosition)
	var time = distance/speed #physics 101
	
	activeTween = self.create_tween()
	activeTween.set_trans(Tween.TRANS_QUAD)
	activeTween.tween_property(body, "global_position", nextPosition, time)
	
	activeTween.play()
	
	activeTween.finished.connect(func():
		var nextIndex = index+1
		if nextIndex >= positions.size(): #loop around
			nextIndex = 0
		
		tweenToPositionIndex(nextIndex)
	)
	
func cancelCurrentTween():
	if activeTween:
		activeTween.kill()
		activeTween = null

func startMovement():
	cancelCurrentTween()
	body.global_position = initialPosition
	tweenToPositionIndex(0)
