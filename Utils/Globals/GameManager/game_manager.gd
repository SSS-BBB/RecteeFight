### GameManager
extends Node

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
