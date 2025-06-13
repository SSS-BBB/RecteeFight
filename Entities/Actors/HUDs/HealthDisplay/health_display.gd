class_name HealthDisplay extends Control

# Export variables
@export var _health_component: HealthComponent

# Component variables
@onready var _health_bar: ProgressBar = %HealthBar

func _ready() -> void:
	if not _health_component:
		push_error("_health_component is not initialized in health display. Cannot display health.")
		return
	
	_health_bar.max_value = _health_component.get_max_health()
	_health_component.health_update.connect(_on_health_update)

func _on_health_update(health: int) -> void:
	_health_bar.value = health
