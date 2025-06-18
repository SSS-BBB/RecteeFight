class_name RobotDestroyedComponent extends Node2D

@export var _actor_body: PhysicsBody2D
@export var _health_component: HealthComponent
@export var _drop_chance_list: Array[DropChanceResource]
@export_group("Drop Properties")
@export var _drop_radius: float = 50.0
@export var _drop_min_distance: float = 5.0 # minimun distance between every drops

var _drops_position: Array[Vector2]

func _ready() -> void:
	if not _health_component:
		push_error("RobotDestroyedComponent: _health_component is not initialized. cannot do anything after robot's health is 0.")
		return
	
	_health_component.actor_die.connect(_on_destroyed)

func _on_destroyed() -> void:
	_drop_upgrade()
	_destroy()

func _drop_upgrade() -> void:
	if not _drop_chance_list:
		push_error("RobotDestroyedComponent: _drop_chance_list is not initialized. cannot drop upgrade.")
		return
	
	for drop_data in _drop_chance_list:
		var rand_drop_chance: float = randf()
		if rand_drop_chance < drop_data.drop_chance or drop_data.drop_chance >= 1.0:
			_create_upgrade_potion(drop_data)

func _create_upgrade_potion(drop_data: DropChanceResource) -> bool:
	var upgrade_resource: UpgradePotionResource
	match drop_data.upgrade_effect:
		UpgradePotionResource.Effect.CURRENT_HEALTH:
			upgrade_resource = UpgradePotionResource.new_current_health_upgrade_resource(drop_data.get_value_i())
		UpgradePotionResource.Effect.MAX_HEALTH:
			upgrade_resource = UpgradePotionResource.new_max_health_upgrade_resource(drop_data.get_value_i())
		UpgradePotionResource.Effect.SPEED:
			upgrade_resource = UpgradePotionResource.new_speed_upgrade_resource(drop_data.get_value_f())
		UpgradePotionResource.Effect.ATTACK_SPEED:
			upgrade_resource = UpgradePotionResource.new_attack_speed_upgrade_resource(drop_data.get_value_f())
		UpgradePotionResource.Effect.DAMAGE:
			upgrade_resource = UpgradePotionResource.new_damage_upgrade_resource(drop_data.get_value_i())
		_:
			push_error("RobotDestroyedComponent: effect " + str(drop_data.upgrade_effect) + " is not implemented yet.")
			return false
	
	if not upgrade_resource:
		return false
	
	return _spawn_upgrade_potion(upgrade_resource)

func _spawn_upgrade_potion(upgrade_potion_resource: UpgradePotionResource) -> bool:
	var container: Node2D = get_tree().get_first_node_in_group("upgrade_potion_container")
	var potion: UpgradePotion = UpgradePotion.new_upgrade_potion(upgrade_potion_resource, _get_upgrade_spawn_position())
	
	if container:
		container.call_deferred("add_child", potion)
	elif _actor_body:
		push_warning("RobotDestroyedComponent: cannot find node with group upgrade_potion_container. add the potion to _actor_body instead.")
		_actor_body.call_deferred("add_child", potion)
	else:
		push_error("RobotDestroyedComponent: cannot find node with group upgrade_potion_container, and _actor_body is not initialized. cannot spawn upgrade potion.")
		return false
	
	_drops_position.append(potion.global_position)
	
	return true

func _get_upgrade_spawn_position() -> Vector2:
	var rand_drop: Vector2 = Vector2(randf_range(-_drop_radius, _drop_radius), randf_range(-_drop_radius, _drop_radius))
	var spawn_position: Vector2 = _actor_body.global_position + rand_drop
	
	var count: int = 0
	var max_count: int = 100
	while not _is_valid_drop(spawn_position) and count <= max_count:
		rand_drop = Vector2(randf_range(-_drop_radius, _drop_radius), randf_range(-_drop_radius, _drop_radius))
		spawn_position = _actor_body.global_position + rand_drop
		count += 1
	
	if not _is_valid_drop(spawn_position):
		push_warning("RobotDestroyedComponent: cannot find valid upgrade drop position. some drop potions might be overlapping.")
	
	
	return spawn_position

func _is_valid_drop(position_to_check: Vector2) -> bool:
	for taken_position in _drops_position:
		if position_to_check.distance_to(taken_position) < _drop_min_distance:
			return false
	
	return true

func _destroy() -> void:
	if not _actor_body:
		push_error("RobotDestroyedComponent: _actor_body is not initialized. cannot queue free this body.")
		return
	
	_actor_body.call_deferred("queue_free")
