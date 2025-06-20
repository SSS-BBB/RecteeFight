### GameManager
extends Node

signal wave_changed

var _current_wave: int
var _highest_wave: int

func _ready() -> void:
	# TODO: Load from save
	_current_wave = 1
	_highest_wave = _current_wave

# Find Components
func find_health_component(node: Node2D) -> HealthComponent:
	for child in node.get_children():
		if child is HealthComponent:
			return child
		elif child.is_in_group("components_container"):
			return find_health_component(child)
	
	return null

func find_knockback_component(node: Node2D) -> KnockbackComponent:
	for child in node.get_children():
		if child is KnockbackComponent:
			return child
		elif child.is_in_group("components_container"):
			return find_knockback_component(child)
	
	return null

func find_apply_effect_component(node: Node2D) -> ApplyEffectComponent:
	for child in node.get_children():
		if child is ApplyEffectComponent:
			return child
		elif child.is_in_group("components_container"):
			return find_apply_effect_component(child)
	
	return null

# Random radius value
func randi_radius(center: int, radius: int, minimum: int = 1) -> int:
	if radius == 0:
		return center
	
	var a: int = (center - radius) if center - radius >= minimum else minimum
	return randi_range(a, center + radius)

func randf_radius(center: float, radius: float, minimum: float = 1.0) -> float:
	if radius == 0.0:
		return center
	
	var a: float = (center - radius) if center - radius >= minimum else minimum
	return randf_range(a, center + radius)

# Wave Systems
func wave_value_upgrade_i(value: int, rate: int) -> int:
	return value + rate * (_current_wave - 1)

func wave_value_upgrade_f(value: float, rate: float) -> float:
	return value + rate * (_current_wave - 1.0)

func next_wave() -> void:
	_current_wave += 1
	wave_changed.emit()

func get_current_wave() -> int:
	return _current_wave

func get_highest_wave() -> int:
	return _highest_wave
