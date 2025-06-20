class_name Player extends CharacterBody2D

# Variables
@onready var _player_control: PlayerControl = %PlayerControl
@onready var _health_component: HealthComponent = %HealthComponent
@onready var _melee_attack_component: MeleeAttackComponent = %MeleeAttackComponent

# Functions
func get_health_component() -> HealthComponent:
	return _health_component

func get_player_control() -> PlayerControl:
	return _player_control

func get_melee_attack_component() -> MeleeAttackComponent:
	return _melee_attack_component
