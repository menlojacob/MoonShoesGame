extends Camera2D

var shiftX = 0
var shiftY = 0
var cameraZoom = 4

func setCamera(camX, camY, camZoom):
	offset.x = camX * 100
	offset.y = camY * 100
	zoom = Vector2.ONE * camZoom
