class_name EnemySpawnPropertyResource extends Resource

@export var _enemy_scene: PackedScene
@export var _wave_dependent: bool = true
@export_group("Enimies Properties")
@export var _enemy_size: Vector2 = Vector2(16, 48)
@export var _enemy_scale: Vector2 = 2 * Vector2.ONE
@export_group("Spawn Properties")
@export var _init_enemy_amount: int = 1
@export var _enemy_increase_per_wave: float = 1.0
@export var _spawn_at_wave: int = 1 # start spawning at which wave
@export var _spawn_to_group: String

func get_enemy_amount() -> int:
	if GameManager.get_current_wave() < _spawn_at_wave:
		return 0
	
	if _wave_dependent:
		# make sure it's greater than 0
		return max(0, floori(_init_enemy_amount + (GameManager.get_current_wave() - _spawn_at_wave) * _enemy_increase_per_wave))
	return _init_enemy_amount

func get_enemy_scene() -> PackedScene:
	return _enemy_scene

func get_enemy_size() -> Vector2:
	return _enemy_size

func get_enemy_scale() -> Vector2:
	return _enemy_scale

func get_spawn_to_group() -> String:
	return _spawn_to_group
