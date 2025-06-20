class_name CheckOverlapComponent extends Area2D

@onready var _collision_shape: CollisionShape2D = %CollisionShape2D

@export var _parent_node: Node2D

func does_position_overlap(pos: Vector2, rect_size: Vector2 = Vector2.ZERO) -> bool:
	global_position = pos
	if rect_size != Vector2.ZERO:
		var rect_shape: RectangleShape2D = RectangleShape2D.new()
		rect_shape.size = rect_size
		_collision_shape.shape = rect_shape
	
	if not _parent_node:
		var error_message: String = "CheckOverlapComponent: _parent_node is not initialized. cannot check if overlapping with itself."
		push_error(error_message)
		UIManager.show_error(error_message)
		return false
	
	var overlap_bodies: Array[Node2D] = get_overlapping_bodies()
	
	if (overlap_bodies.size() == 1 and overlap_bodies[0] == _parent_node) or overlap_bodies.size() == 0:
		return false
	
	return true
