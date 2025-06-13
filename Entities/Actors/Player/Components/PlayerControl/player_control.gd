class_name PlayerControl extends Node2D

# Variables
@export var _player_body: CharacterBody2D
@export_group("Player Movement")
@export var _init_player_speed: float = 500.0
@export var _speed_multiplier: float = 35.0

var _player_speed: float

# Functions
func _ready() -> void:
	_player_speed = _init_player_speed

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_player_body.velocity = _player_speed * _speed_multiplier * direction * delta
	_player_body.move_and_slide()
