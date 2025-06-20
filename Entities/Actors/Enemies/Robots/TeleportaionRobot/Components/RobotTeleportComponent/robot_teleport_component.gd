class_name RobotTeleportComponent extends Node2D

@onready var _check_intersect_area: Area2D = %CheckIntersectArea

@export var _actor_body: PhysicsBody2D
@export var _melee_attack_component: MeleeAttackComponent
@export var _teleport_audio_player: AudioStreamPlayer2D
@export var _wave_dependent: bool = false
@export_group("Teleportation Properties")
@export var _init_teleport_radius: float = 300.0
@export var _teleport_radius_range_radius: float = 0.0

var _teleporting: bool
var _teleport_radius: float

func _ready() -> void:
	if _wave_dependent:
		_teleport_radius = GameManager.wave_value_upgrade_f(_init_teleport_radius, 10.0)
	else:
		_teleport_radius = _init_teleport_radius
	
	_teleporting = false
	_teleport_radius = GameManager.randf_radius(_teleport_radius, _teleport_radius_range_radius, 50.0)
	
	if not _melee_attack_component:
		push_error("RobotTeleportComponent: _melee_attack_component is not initialized. cannot teleport robot after attacks.")
		return
	
	_melee_attack_component.finished_attack.connect(_start_teleporting)

func _start_teleporting() -> void:
	if _teleporting:
		return
	
	_teleporting = true
	_teleport()

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
	else:
		push_warning("RobotTeleportComponent: _teleport_audio_player is not initialized. cannot play teleporting audio")
	
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
