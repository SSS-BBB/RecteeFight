class_name RobotShootingComponent extends Node2D

@export var _actor_body: PhysicsBody2D
@export var _multiple_rays: MultipleRays
@export var _wave_dependent: bool = false
@export var _shooting_audio_player: AudioStreamPlayer2D

@export_group("Shooting Properties")
@export var _init_damage: int = 3
@export var _init_bullet_speed: float = 450.0
@export var _init_fire_rate: float = 2.0
@export var _init_pause_time_before_shooting: float = 0.5
@export var _init_knockback_force: float = 200.0
@export var _init_knockback_decerlation: float = 200.0

@export var _damage_range_radius: int = 2
@export var _bullet_speed_range_radius: float = 80.0
@export var _fire_rate_range_radius: float = 0.5

@export_group("Bullet Properties")
@export var _bullet_scale: float = 1.5

var _damage: int
var _bullet_speed: float
var _fire_rate: float

var _shooting_time_left: float
var _pause_time_before_shooting: float

var _knockback_force: float
var _knockback_decerlation: float

var _player: Player
var _bullet_container: Node2D

var _shooting_position: Vector2
var _shooting_direction: Vector2

func _ready() -> void:
	if _wave_dependent:
		_damage = _init_damage
		_bullet_speed = _init_bullet_speed
		_fire_rate = _init_fire_rate
		_knockback_force = _init_knockback_force
		_knockback_decerlation = _init_knockback_decerlation
		_pause_time_before_shooting = _init_pause_time_before_shooting
	else:
		_damage = _init_damage
		_bullet_speed = _init_bullet_speed
		_fire_rate = _init_fire_rate
		_knockback_force = _init_knockback_force
		_knockback_decerlation = _init_knockback_decerlation
		_pause_time_before_shooting = _init_pause_time_before_shooting
	
	_damage = GameManager.randi_radius(_damage, _damage_range_radius)
	_bullet_speed = GameManager.randf_radius(_bullet_speed, _bullet_speed_range_radius)
	_fire_rate = GameManager.randf_radius(_fire_rate, _fire_rate_range_radius)

	_shooting_time_left = 0.0
	
	_bullet_container = get_tree().get_first_node_in_group("bullet_container")
	
	if not _multiple_rays:
		push_error("RobotShootingComponent: _multiple_rays is not initialized. cannot detect player to shoot.")
		return
	
	_multiple_rays.ray_hit_player.connect(_start_shooting)
	
	if _pause_time_before_shooting > _fire_rate:
		push_warning("RobotShootingComponent: _pause_time_before_shooting is greater than _fire_rate. this might caused some unexpected behaviour.")

func _process(delta: float) -> void:
	if not is_shooting():
		return
	
	_shooting_time_left -= delta
	
	if _shooting_time_left <= 0.0:
		_shooting_time_left = 0.0
		queue_redraw()

func _draw() -> void:
	if not is_shooting():
		return
	
	# draw a line between the robot and the player
	draw_line(Vector2.ZERO, _player.global_position - _actor_body.global_position, Color.RED, 1)

func _start_shooting(player: Player) -> void:
	if is_shooting():
		return
	
	_shooting_time_left = _fire_rate
	_player = player
	_shooting_position = _actor_body.global_position
	_shooting_direction = _actor_body.global_position.direction_to(_player.global_position)
	queue_redraw() # draw line
	
	# pause before shooting
	await get_tree().create_timer(_pause_time_before_shooting).timeout
	_shoot()

func _shoot() -> void:
	# spawn bullet
	var bullet: Bullet = Bullet.new_bullet(_damage, _bullet_speed, _knockback_force, _knockback_decerlation, _shooting_position, _shooting_direction, _bullet_scale * Vector2.ONE)
	if _bullet_container:
		_bullet_container.add_child(bullet)
	else:
		_actor_body.add_child(bullet)
		push_warning("RobotShootingComponent: cannot finde node with group bullet_container. add bullet to _actor_body instead.")
	
	# play shooting sfx
	if _shooting_audio_player:
		_shooting_audio_player.play()
	else:
		push_warning("RobotShootingComponent: _shooting_audio_player is not initialized. cannot play shooting audiod")
	
	
func is_shooting() -> bool:
	return _shooting_time_left > 0.0
	
