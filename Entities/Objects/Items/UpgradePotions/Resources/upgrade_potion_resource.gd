class_name UpgradePotionResource extends Resource

@export var texture: Texture
@export var size: Vector2i = 16 * Vector2i.ONE
@export var cell_position: Vector2i = Vector2i.ZERO
@export var get_audio: AudioStream
@export var effect: Effect
@export var value_i: int
@export var value_f: float

# const RESOURCE_SCENE: Resource = preload("res://Entities/Objects/Items/UpgradePotions/Resources/upgrade_potion_resource.gd")

enum Effect {
	CURRENT_HEALTH, MAX_HEALTH, SPEED, ATTACK_SPEED, DAMAGE
}

static func new_current_health_upgrade_resource(value: int) -> UpgradePotionResource:
	var potion_resource: UpgradePotionResource = UpgradePotionResource.new()
	potion_resource._set_default_value()
	potion_resource.cell_position = Vector2i(0, 0)
	potion_resource.effect = Effect.CURRENT_HEALTH
	potion_resource.value_i = value
	return potion_resource

static func new_max_health_upgrade_resource(value: int) -> UpgradePotionResource:
	var potion_resource: UpgradePotionResource = UpgradePotionResource.new()
	potion_resource._set_default_value()
	potion_resource.cell_position = Vector2i(0, 1)
	potion_resource.effect = Effect.MAX_HEALTH
	potion_resource.value_i = value
	return potion_resource

static func new_speed_upgrade_resource(value: float) -> UpgradePotionResource:
	var potion_resource: UpgradePotionResource = UpgradePotionResource.new()
	potion_resource._set_default_value()
	potion_resource.cell_position = Vector2i(0, 2)
	potion_resource.effect = Effect.SPEED
	potion_resource.value_f = value
	return potion_resource

static func new_attack_speed_upgrade_resource(value: float) -> UpgradePotionResource:
	var potion_resource: UpgradePotionResource = UpgradePotionResource.new()
	potion_resource._set_default_value()
	potion_resource.cell_position = Vector2i(0, 3)
	potion_resource.effect = Effect.ATTACK_SPEED
	potion_resource.value_f = value
	return potion_resource

static func new_damage_upgrade_resource(value: int) -> UpgradePotionResource:
	var potion_resource: UpgradePotionResource = UpgradePotionResource.new()
	potion_resource._set_default_value()
	potion_resource.cell_position = Vector2i(0, 4)
	potion_resource.effect = Effect.DAMAGE
	potion_resource.value_i = value
	return potion_resource

func _set_default_value() -> void:
	texture = preload("res://Entities/Objects/Items/UpgradePotions/Textures/upgrade_potions.png")
	get_audio = preload("res://Entities/Objects/Items/UpgradePotions/SFXs/upgrade_pickup.wav")
