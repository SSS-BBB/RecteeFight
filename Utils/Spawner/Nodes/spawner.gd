class_name Spawner extends Node2D

@onready var _check_overlap_component: CheckOverlapComponent = %CheckOverlapComponent

@export var _enemy_to_spawn: Array[EnemySpawnPropertyResource] # All the enimies to spawn on each wave
@export var _spawn_radius: float = 1500.0

var _spawn_center: Vector2

func _ready() -> void:
	_spawn_center = get_viewport().size / 2.0
	
	GameManager.wave_changed.connect(_on_wave_changed)
	_on_wave_changed()

func _on_wave_changed() -> void:
	if not _enemy_to_spawn:
		var error_message: String = "Spawner: _enemy_to_spawn is not initialized. cannot spawn enimies."
		push_error(error_message)
		UIManager.show_error(error_message)
		return
	
	for to_spawn in _enemy_to_spawn:
		_spawn_enemy(to_spawn)

func _spawn_enemy(enemy_spawn_property: EnemySpawnPropertyResource) -> void:
	for i in range(enemy_spawn_property.get_enemy_amount()):
		var spawn_position: Vector2 = _get_non_overlap_spawn_position(enemy_spawn_property)
		var spawn_container: Node2D = get_tree().get_first_node_in_group(enemy_spawn_property.get_spawn_to_group())
		
		# set properties
		var spawn_node: Node2D = enemy_spawn_property.get_enemy_scene().instantiate()
		spawn_node.scale = enemy_spawn_property.get_enemy_scale()
		spawn_node.global_position = spawn_position
		if spawn_container:
			spawn_container.add_child(spawn_node)
		else:
			add_child(spawn_node)
			var warning_message: String = "Spawner: cannot find spawn container with group " + enemy_spawn_property.get_spawn_to_group() + ". add enemy to spawner node instead."
			push_warning(warning_message)
			UIManager.show_warning(warning_message)

func _get_non_overlap_spawn_position(enemy_spawn_property: EnemySpawnPropertyResource) -> Vector2:
	var enemy_size: Vector2 = Vector2(enemy_spawn_property.get_enemy_size().x * enemy_spawn_property.get_enemy_scale().x, enemy_spawn_property.get_enemy_size().y * enemy_spawn_property.get_enemy_scale().y)
	
	var rand_center_offset: Vector2 = Vector2(randf_range(-_spawn_radius, _spawn_radius), randf_range(-_spawn_radius, _spawn_radius))
	var spawn_position: Vector2 = _spawn_center + rand_center_offset
	
	var count_loop: int = 0
	var max_count_loop: int = 100
	while _check_overlap_component.does_position_overlap(spawn_position, enemy_size) and count_loop <= max_count_loop:
		rand_center_offset = Vector2(randf_range(-_spawn_radius, _spawn_radius), randf_range(-_spawn_radius, _spawn_radius))
		spawn_position = _spawn_center + rand_center_offset
		count_loop += 1
	
	if _check_overlap_component.does_position_overlap(spawn_position, enemy_size):
		var warning_message: String = "Spawner: cannot find non overlap spawn position. enemy might be overlapping."
		push_warning(warning_message)
		UIManager.show_warning(warning_message)
	
	return spawn_position
