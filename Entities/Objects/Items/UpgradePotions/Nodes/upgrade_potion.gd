@tool
class_name UpgradePotion extends Area2D

const UPGRADE_POTION_SCENE: PackedScene = preload("res://Entities/Objects/Items/UpgradePotions/Nodes/upgrade_potion.tscn")

@onready var _sprite: Sprite2D = %Sprite2D
@export var _upgrade_potion_resource: UpgradePotionResource

static func new_upgrade_potion(resource: UpgradePotionResource, pos: Vector2, potion_scale: Vector2 = 1.2 * Vector2.ONE) -> UpgradePotion:
	var potion: UpgradePotion = UPGRADE_POTION_SCENE.instantiate()
	potion._upgrade_potion_resource = resource
	potion.global_position = pos
	potion.scale = potion_scale
	return potion

func _ready() -> void:
	# set sprite texture if exist
	if _upgrade_potion_resource.texture:
		_sprite.texture = _upgrade_potion_resource.texture
	
	# set sprite region
	var _position: Vector2i
	_position.x = _upgrade_potion_resource.cell_position.x * _upgrade_potion_resource.size.x
	_position.y = _upgrade_potion_resource.cell_position.y * _upgrade_potion_resource.size.y
	_sprite.region_enabled = true
	_sprite.region_rect = Rect2(_position, _upgrade_potion_resource.size)
