class_name PlayerControl extends Node2D

# Variables
@export var _player_body: CharacterBody2D
@export_group("Player Movement")
@export var _init_player_speed: float = 500.0
@export var _speed_multiplier: float = 35.0
@export_group("Player Attack")
@export var _melee_attack_component: MeleeAttackComponent

var _player_speed: float
var _direction: Vector2

# Functions
func _ready() -> void:
	_player_speed = _init_player_speed
	_direction = Vector2(1.0, 0.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if _melee_attack_component:
			_melee_attack_component._attack(_direction)
		else:
			push_error("_melee_attack_component is not initialized in player control. Cannot attack.")

func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if not _player_body:
		push_error("_player_body is not initialized in player control. Cannot move.")
		return
	
	_player_body.velocity = _player_speed * _speed_multiplier * _direction * delta
	_player_body.move_and_slide()
