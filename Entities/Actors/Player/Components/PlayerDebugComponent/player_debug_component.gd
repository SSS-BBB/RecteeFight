class_name PlayerDebugComponent extends Node2D

@export var _health_component: HealthComponent # current health, max health
@export var _player_control: PlayerControl # speed
@export var _melee_attack_component: MeleeAttackComponent # attck speed, damage
@export var _apply_effect_component: ApplyEffectComponent

func _ready() -> void:
	if not _apply_effect_component:
		push_error("PlayerDebugComponent: _apply_effect_component is not initialized. cannot see player stats after effects are applied.")
		return
	_apply_effect_component.effect_applied.connect(_show_stats)
	_show_stats()

func _show_stats() -> void:
	print("Player Stats")
	if _health_component:
		print("Current Health: " + str(_health_component.get_current_health()))
		print("Max Health: " + str(_health_component.get_max_health()))
	else:
		push_warning("PlayerDebugComponent: _health_component is not initialized. cannot show player's current health and max health.")
	
	if _player_control:
		print("Speed: " + str(_player_control.get_speed()))
	else:
		push_warning("PlayerDebugComponent: _player_control is not initialized. cannot show player's speed.")
	
	if _melee_attack_component:
		print("Attack Duration: " + str(_melee_attack_component.get_attack_duration()))
		print("Attack Damage: " + str(_melee_attack_component.get_attack_damage()))
	else:
		push_warning("PlayerDebugComponent: _melee_attack_component is not initialized. cannot show player's attack duration and damage.")
	
	print("--------------------------------------------------")
	
