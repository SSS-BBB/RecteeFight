class_name RobotTeleportComponent extends Node2D

@onready var _timer: Timer = %Timer
@onready var _check_intersect_area: Area2D = %CheckIntersectArea

@export var _actor_body: PhysicsBody2D
@export var _multiple_rays: MultipleRays
@export var _teleport_audio_player: AudioStreamPlayer2D
@export var _wave_dependent: bool = false
@export_group("Teleportation Properties")
@export var _init_teleport_radius: float = 300.0
@export var _init_teleport_time: float = 2.5
@export var _teleport_radius_range_radius: float = 0.0
@export var _teleport_time_range_radius: float = 0.0

var _teleporting: bool
var _teleport_radius: float

func _ready() -> void:
	if _wave_dependent:
		pass
	
	_teleporting = false
	_teleport_radius = _init_teleport_radius
	_teleport_radius = GameManager.randf_radius(_teleport_radius, _teleport_radius_range_radius, 50.0)
	
	if not _multiple_rays:
		push_error("RobotTeleportComponent: _multiple_rays is not initialized. cannot teleport when sees player.")
		return
	
	_multiple_rays.ray_hit_player.connect(_start_teleporting)

func _start_teleporting(_player: Player) -> void:
	if _teleporting:
		return
	
	_teleporting = true
	var teleport_time: float = GameManager.randf_radius(_init_teleport_time, _teleport_time_range_radius)
	_timer.wait_time = teleport_time
	_timer.start()

func _teleport() -> void:
	
	var rand_teleport: Vector2 = Vector2(randf_range(-_teleport_radius, _teleport_radius), randf_range(-_teleport_radius, _teleport_radius))
	var rand_position: Vector2 = _actor_body.global_position + rand_teleport
	rand_position = _get_non_overlap_position(rand_position)
	
	if rand_position == Vector2.ZERO:
		push_warning("RobotTeleportComponent: cannot find position that is not overlapping with other bodies.")
		_teleporting = false
		return
	
	if _teleport_audio_player:
		_teleport_audio_player.play()
	
	_actor_body.global_position = rand_position
	_check_intersect_area.global_position = _actor_body.global_position
	
	_teleporting = false

func _get_non_overlap_position(overlap_position: Vector2, count: int = 0) -> Vector2:
	_check_intersect_area.global_position = overlap_position
	
	if count >= 100:
		return Vector2.ZERO
	
	var overlap_bodies: Array[Node2D] = _check_intersect_area.get_overlapping_bodies()
	if (overlap_bodies.size() == 1 and overlap_bodies[0] == _actor_body) or overlap_bodies.size() == 0:
		return overlap_position
	
	var rand_teleport: Vector2 = Vector2(randf_range(-_teleport_radius, _teleport_radius), randf_range(-_teleport_radius, _teleport_radius))
	var rand_position: Vector2 = _actor_body.global_position + rand_teleport
	return _get_non_overlap_position(rand_position, count + 1)
