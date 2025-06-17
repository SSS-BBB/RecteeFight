class_name GameCamera extends Camera2D

@onready var _camera_shaking_component: CameraShakingComponent = %CameraShakingComponent

@export var _player: Player

func _ready() -> void:
	if not _player:
		push_error("GameCamera: _player is not initialized. cannot shake the camera when the player is attacked.")
		return
	
	var player_health_component: HealthComponent = GameManager.find_health_component(_player)
	player_health_component.actor_attacked.connect(_camera_shaking_component.start_shaking)
	
