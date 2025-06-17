@tool
class_name MultipleRays extends Node2D

# Export variables
@export var auto_ray_add: bool = true:
	set(value):
		auto_ray_add = value
		notify_property_list_changed()
@export_category("Ray Properties")
@export var ray_size: float = 50.0
@export var ray_offset: Vector2 = Vector2.ZERO
@export var horizontal_ray: int = -1 # -1 -> left, 1 -> right
@export var more_rays: bool = false

signal ray_hit_player(player: Player)

# Game functions
func _validate_property(property: Dictionary) -> void:
	if (property.name == "ray_size" or property.name == "ray_offset") and not auto_ray_add:
		property.usage |= PROPERTY_USAGE_READ_ONLY

func _ready() -> void:
	if auto_ray_add:
		add_multiple_rays()

func _physics_process(_delta: float) -> void:
	var hit: Node2D = rays_target_collider("player")
	if not hit:
		return
	var player: Player = hit as Player
	ray_hit_player.emit(player)

# Class functions
func add_multiple_rays() -> void:
	remove_all_rays()
	
	add_ray(0)
	
	add_up_and_down_ray(PI/4)
	add_up_and_down_ray(PI/2)
	add_up_and_down_ray(3*PI/4)
	
	if more_rays:
		add_up_and_down_ray(PI/8)
		add_up_and_down_ray(3*PI/8)
		add_up_and_down_ray(5*PI/8)
		add_up_and_down_ray(7*PI/8)
	
	add_ray(PI)

func add_up_and_down_ray(angle: float) -> void:
	add_ray(angle)
	add_ray(-angle)

func add_ray(angle: float) -> void:
	var ray := RayCast2D.new()
	ray.target_position.x = ray_size * cos(angle) * horizontal_ray
	ray.target_position.y = ray_size * sin(angle)
	ray.position += ray_offset
	add_child(ray)
	
func remove_all_rays() -> void:
	for child in get_children():
		if child is RayCast2D:
			remove_child(child)

func rays_target_collider(target_group: String) -> Node2D:
	# return the object that rays is intersecting if it is in the target group
	
	for child in get_children():
		var ray: RayCast2D = child as RayCast2D
		if not ray.is_colliding():
			continue
		
		var colliding: Node2D = ray.get_collider()
		if colliding.is_in_group(target_group):
			# rays hit target
			return colliding
	
	# rays do not hit target
	return null
