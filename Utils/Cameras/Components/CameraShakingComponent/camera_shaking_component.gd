class_name CameraShakingComponent extends Node2D

# Export variables
@export var camera: Camera2D
@export var shake_force: float = 1.5
@export var _shake_duration: float = 0.5

var _shaking_time_left: float

# Game functions
func _ready() -> void:
	_shaking_time_left = 0.0

func _process(delta: float) -> void:
	if _shaking_time_left <= 0.0:
		return
	
	shake_camera()
	_shaking_time_left -= delta

# Class functions
func start_shaking(_damage: int) -> void:
	_shaking_time_left = _shake_duration

func shake_camera() -> void:
	if not camera:
		push_error("CameraShakingComponent: camera is not initialized. cannot shake a camera.")
		return
	
	camera.offset = Vector2(randf_range(-shake_force, shake_force), randf_range(-shake_force, shake_force))
