class_name Player extends CharacterBody2D

# Variables
@onready var _health_component: HealthComponent = %HealthComponent



# Functions
func get_health_component() -> HealthComponent:
	return _health_component
