class_name MoveToTargetComponent extends Node2D

# Variables
@export var _target_group_name: String
@export var _actor_body: CharacterBody2D
@export var _knockback_component: KnockbackComponent
@export var _robot_shooting_component: RobotShootingComponent
@export var _wave_dependent: bool = false
@export_group("Movement Properties")
@export var _init_move_speed: float = 25.0
@export var _move_speed_range_radius: float = 0.0
@export var _speed_multiplier: float = 3.0
@export var _min_distance_to_target: float = 100.0

var _move_speed: float
var _target: Node2D

# Functions
func _ready() -> void:
	if _wave_dependent:
		pass
	
	_move_speed = GameManager.randf_radius(_init_move_speed, _move_speed_range_radius)
	_target = get_tree().get_first_node_in_group(_target_group_name)

func _physics_process(_delta: float) -> void:
	if not _target:
		return
	
	if not _actor_body:
		push_error("MoveToTargetComponent: _actor_body is not initialized. actor cannot move")
		return
	
	if _actor_body.global_position.distance_to(_target.global_position) < _min_distance_to_target:
		# _actor_body.global_position += _actor_body.global_position.direction_to(target.global_position) * _min_distance_to_target
		return
	
	if _knockback_component:
		if _knockback_component.is_knockbacking():
			return
	else:
		push_warning("MoveToTargetComponent: _knockback_component is not initialized. cannot check if the actor is being knockbacked.")
	
	if _robot_shooting_component and _robot_shooting_component.is_shooting():
		return
	
	var direction: Vector2 = _actor_body.global_position.direction_to(_target.global_position)
	_actor_body.velocity = _move_speed * _speed_multiplier * direction
	_actor_body.move_and_slide()
	
