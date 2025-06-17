class_name PlayerControl extends Node2D

# Variables
@export var _player_body: CharacterBody2D
@export var _knockback_component: KnockbackComponent
@export_group("Player Movement")
@export var _init_player_speed: float = 80.0
@export var _speed_multiplier: float = 3.0
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
			push_error("PlayerControl: _melee_attack_component is not initialized in player control. cannot attack.")

func _physics_process(_delta: float) -> void:
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if not _player_body:
		push_error("PlayerControl: _player_body is not initialized. cannot move.")
		return
	
	if _knockback_component:
		if _knockback_component.is_knockbacking():
			return
	else:
		push_warning("PlayerControl: _knockback_component is not initialized. cannot check if player is being knockbacked.")
	
	_player_body.velocity = _player_speed * _speed_multiplier * _direction
	_player_body.move_and_slide()
	_offscreen_movement()

func _offscreen_movement() -> void:
	# if player is offscreen player will re-appear on the opposite sides
	
	# horizontal offscreen check
	if _player_body.global_position.x <= 0.0:
		_player_body.global_position.x += get_viewport().size.x
	elif _player_body.global_position.x >= get_viewport().size.x:
		_player_body.global_position.x -= get_viewport().size.x
	
	 # vertical offscreen check
	if _player_body.global_position.y <= 0.0:
		_player_body.global_position.y += get_viewport().size.y
	elif _player_body.global_position.y >= get_viewport().size.y:
		_player_body.global_position.y -= get_viewport().size.y
