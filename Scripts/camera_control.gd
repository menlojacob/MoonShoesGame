extends Area2D

@export var shiftX = 0
@export var shiftY = 0
@export var zoom = 4

func _on_body_entered(body: Node2D) -> void:
	var playerCamera = body.get_node_or_null("PlayerCamera")
	if playerCamera:
		playerCamera.setCamera(shiftX, shiftY, zoom)
