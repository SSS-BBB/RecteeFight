class_name HealthComponent extends Node2D

# variables
@export var _init_max_health: int = 15
@export var _attacked_audio_player: AudioStreamPlayer2D
@export var _wave_dependent: bool = false # if wave dependent stats will change depends on the current wave
@export var _max_health_range_radius: int = 0 # random range radius
@export_group("On Attacked Animation")
@export var _animation_on_attacked: AnimationPlayer # animation to play when being attacked.
@export var _attacked_animation_name: String
@export_group("On Gain Health Animation")
@export var _animation_on_gain_health: AnimationPlayer # animation to play when health gained.
@export var _gain_health_animation_name: String

var _max_health: int
var _health: int

# signals
signal actor_die
signal health_update
signal actor_attacked
signal health_update_failed

func _ready() -> void:
	if _wave_dependent:
		_max_health = _init_max_health
		# do something
	else:
		_max_health = _init_max_health
	
	_max_health = randi_range(_max_health - _max_health_range_radius, _max_health + _max_health_range_radius)
	_max_health = max(1, _max_health) # make sure _max_health is greater than 0
	
	_health = _max_health
	health_update.emit(_health)
	
func take_damage(damage: int) -> void:
	if damage < 0:
		push_warning("Damage less than 0. This might cause actor to gaining health instead of losing health. If you want actor to gain health, you should use gain_health method instead.")
	
	_health -= damage
	if _attacked_audio_player:
		_attacked_audio_player.play()
	
	actor_attacked.emit(damage)
	if _health <= 0:
		actor_die.emit()
		_health = 0
	health_update.emit(_health)
	
	if _animation_on_attacked:
		if _attacked_animation_name.is_empty():
			_animation_on_attacked.play()
			push_warning("Health Component: _attacked_animation_name is not given.")
		else:
			_animation_on_attacked.play(_attacked_animation_name)
	
func gain_health(health_gain: int) -> bool:
	if health_gain < 0:
		push_warning("Health gain less than 0. This might cause actor to losing health instead of gaining health. If you want actor to lose health, you should use take_damage method instead.")
	
	if _health >= _max_health:
		health_update_failed.emit("[FullHP]")
		return false
	
	_health += health_gain
	
	if _health <= 0:
		actor_die.emit()
		_health = 0
	if _health > _max_health:
		_health = _max_health
		
	health_update.emit(_health)
	
	if _animation_on_gain_health:
		if _gain_health_animation_name.is_empty():
			_animation_on_gain_health.play()
			push_warning("Health Component: _gain_health_animation_name is not given.")
		else:
			_animation_on_gain_health.play(_gain_health_animation_name)
	
	return true

func update_max_health(value: int, update_health: bool = true) -> void:
	_max_health = value
	if update_health:
		_health = _max_health
	
	health_update.emit(_health)

func force_die() -> void:
	_health = 0
	actor_die.emit()

func get_max_health() -> int:
	return _max_health
