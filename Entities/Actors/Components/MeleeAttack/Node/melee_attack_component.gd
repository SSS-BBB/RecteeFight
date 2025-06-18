class_name MeleeAttackComponent extends Node2D

# Variables
@export var _disable: bool = false
@export var _target_groups: Array[String] # groups to attack
@export var _component_container: ComponentsContainer
@export var _wave_dependent: bool = false # if wave dependent stats will change depends on the current wave
@export_group("Attack Properties")
@export var _init_attack_duration: float = 1.0
@export var _init_attack_damage: int = 1
@export var _init_attack_distance: float = 35.0
@export var _attack_duration_range_radius: float = 0.0
@export var _attack_damage_range_radius: int = 0
@export var _attack_distance_range_radius: float = 0.0
@export_group("Punch Properties")
@export var _init_punch_scale: float = 1.0
@export var _default_punch_direction: Vector2 = Vector2(1.0, 0.0) # punch direction when the actor is not moving.
@export var _init_knockback_force: float = 150.0
@export var _init_knockback_decerlation: float = 220.0

@onready var _punch: Area2D = %Punch

signal finished_attack

var _attack_duration: float
var _attack_damage: int
var _attack_distance: float
var _tween: Tween
var _knockback_force: float
var _knockback_decerlation: float

var _punch_scale: float:
	set(value):
		_punch_scale = value
		if _punch:
			_punch.scale = _punch_scale * Vector2.ONE
var _puncing: bool

# Functions
func _ready() -> void:
	if _wave_dependent:
		# do something
		pass
	
	_attack_duration = GameManager.randf_radius(_init_attack_duration, _attack_duration_range_radius) 
	_attack_damage = GameManager.randi_radius(_init_attack_damage, _attack_damage_range_radius)
	_attack_distance = GameManager.randf_radius(_init_attack_distance, _attack_distance_range_radius)
	
	_punch_scale = _init_punch_scale
	_puncing = false
	_knockback_force = _init_knockback_force
	_knockback_decerlation = _init_knockback_decerlation

func _attack(direction_to_attack: Vector2 = _default_punch_direction) -> void:
	if _disable or _puncing:
		return
	
	_puncing = true
	
	# calculate position
	if direction_to_attack == Vector2.ZERO:
		direction_to_attack = _default_punch_direction
	var position_to_attack: Vector2 = _attack_distance * direction_to_attack
	
	# starts punching
	_tween = get_tree().create_tween()
	_tween.tween_property(_punch, "position", position_to_attack, _attack_duration/2.0)
	_tween.tween_property(_punch, "position", Vector2.ZERO, _attack_duration/2.0)
	_tween.tween_callback(_finished_punching)
	_tween.bind_node(self)

func _finished_punching() -> void:
	_puncing = false
	finished_attack.emit()


func _on_body_entered_punch_area(body: Node2D) -> void:
	if not _puncing:
		return
	
	if not _target_groups:
		push_error("target_groups is not initialized in melee_attack_component. cannot check if the body is target.")
		return
	
	# check if the body is the target that this component wants to attack
	var is_target: bool = false
	for target in _target_groups:
		if body.is_in_group(target):
			is_target = true
			break
	
	if not is_target:
		return
	
	# components
	if _component_container:
		var body_health_component: HealthComponent = _component_container._find_health_component(body)
		var body_knockback_component: KnockbackComponent = _component_container._find_knockback_component(body)
	
		# doing damage
		if body_health_component:
			body_health_component.take_damage(_attack_damage)
		else:
			push_warning("cannot find health component from " + body.to_string() + ". Therefore cannot attack this body.")
		
		# knockback
		if body_knockback_component:
			var knockback_direction: Vector2 = _punch.global_position.direction_to(body.global_position)
			body_knockback_component.do_knockback(knockback_direction, _knockback_force, _knockback_decerlation)
		else:
			push_warning("cannot find body knockback component from " + body.to_string() + ". Therefore cannot knockback this body.")
	
	else:
		push_warning("_component_container is not initialized in melee_attack_component. cannot find " + body.to_string() + " components.")
	
	
	# stop punching
	if _tween.is_running():
		_tween.kill()
		
		_tween = get_tree().create_tween()
		_tween.tween_property(_punch, "position", Vector2.ZERO, _attack_duration/2.0)
		_tween.tween_callback(_finished_punching)
		_tween.bind_node(self)
		_tween.play()

func upgrade_attack_speed(value: float) -> bool:
	_attack_duration -= value
	_attack_duration = max(0.01, _attack_duration)
	return true

func upgrade_damage(value: int) -> bool:
	_attack_damage += value
	return true

func get_attack_duration() -> float:
	return _attack_duration

func get_attack_damage() -> int:
	return _attack_damage
