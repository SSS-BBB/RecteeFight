class_name DropChanceResource extends Resource

@export var upgrade_effect: UpgradePotionResource.Effect
@export var init_value_i: int
@export var init_value_f: float
@export var wave_rate_i: int
@export var wave_rate_f: float
@export var wave_dependent: bool = true
@export_range(0.0, 1.0, 0.01) var drop_chance: float

func get_value_i() -> int:
	if wave_dependent:
		return GameManager.wave_value_upgrade_i(init_value_i, wave_rate_i)
	return init_value_i

func get_value_f() -> float:
	if wave_dependent:
		return GameManager.wave_value_upgrade_f(init_value_f, wave_rate_f)
	return init_value_f
