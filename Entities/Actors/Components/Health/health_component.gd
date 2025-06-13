class_name HealthComponent extends Node2D

# variables
@export var _init_max_health: int = 15
@export var _attacked_audio_player: AudioStreamPlayer2D

var _max_health: int
var _health: int

# signals
signal actor_die
signal health_update
signal damage_signal
signal health_update_failed

func _ready() -> void:
	_max_health = _init_max_health
	_health = _max_health
	health_update.emit(_health)
	
func take_damage(damage: int) -> void:
	if damage < 0:
		push_warning("Damage less than 0. This might cause actor to gaining health instead of losing health. If you want actor to gain health, you should use gain_health method instead.")
	
	_health -= damage
	if _attacked_audio_player:
		_attacked_audio_player.play()
	
	damage_signal.emit(damage)
	if _health <= 0:
		actor_die.emit()
		_health = 0
	health_update.emit(_health)
	
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
