class_name AttackOnSeeTargetComponent extends Node2D

# Variables
@export var _actor_body: PhysicsBody2D
@export var _target_group: String
@export var _multiple_rays: MultipleRays
@export var _melee_attack_component: MeleeAttackComponent

# Functions
func _physics_process(_delta: float) -> void:
	if not _multiple_rays:
		push_error("AttackOnSeeTargetComponent: _multiple_rays is not initialized. cannot get rays colluder.")
	
	var target: Node2D = _multiple_rays.rays_target_collider(_target_group)
	
	if not target:
		return
	
	if _melee_attack_component:
		if _actor_body:
			_melee_attack_component._attack(_actor_body.global_position.direction_to(target.global_position))
		else:
			push_warning("AttackOnSeeTargetComponent: _actor_body is not initialized. cannot calculate the direction to attack.")
			_melee_attack_component._attack()
			
	else:
		push_warning("AttackOnSeeTargetComponent: _melee_attack_component is not initialized. cannot attack the target.")
