extends Area2D
@onready var marker_2d: Marker2D = $Marker2D



func _on_area_entered(area: Area2D) -> void:
	GameManager.respawn_point = marker_2d.global_position
