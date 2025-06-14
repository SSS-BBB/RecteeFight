class_name KnockbackComponent extends Node2D

# Variables
@export var _actor_body: CharacterBody2D
@export_range(0.0, 1.0, 0.01) var _init_knockback_reduce: float = 0.1

var _knockbacking: bool
# knockback properties
var _knockback_direction: Vector2
var _knockback_force: float
var _knockback_decerlation: float

var _knockback_reduce: float

# Functions
func _ready() -> void:
	_knockbacking = false
	_knockback_reduce = _init_knockback_reduce

func _physics_process(delta: float) -> void:
	if not _knockbacking:
		return
	
	_actor_body.velocity = _knockback_direction * _knockback_force
	_actor_body.move_and_slide()
	_knockback_force -= _knockback_decerlation * delta
	if _knockback_force <= 0:
		_actor_body.velocity = Vector2.ZERO
		_actor_body.move_and_slide()
		_knockbacking = false

func do_knockback(direction: Vector2, init_force: float, decerlation: float) -> void:
	_knockback_direction = direction
	_knockback_force = init_force * (1.0 - _knockback_reduce)
	_knockback_decerlation = decerlation
	
	_knockbacking = true

func is_knockbacking() -> bool:
	return _knockbacking
