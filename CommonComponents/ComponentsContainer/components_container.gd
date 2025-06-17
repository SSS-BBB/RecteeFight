class_name ComponentsContainer extends Node2D

# Variables

# Functions
func _find_health_component(node: Node2D) -> HealthComponent:
	for child in node.get_children():
		if child is HealthComponent:
			return child
		elif child.is_in_group("components_container"):
			return _find_health_component(child)
	
	return null

func _find_knockback_component(node: Node2D) -> KnockbackComponent:
	for child in node.get_children():
		if child is KnockbackComponent:
			return child
		elif child.is_in_group("components_container"):
			return _find_knockback_component(child)
	
	return null
