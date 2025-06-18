@tool
class_name UpgradePotion extends Area2D

const UPGRADE_POTION_SCENE: PackedScene = preload("res://Entities/Objects/Items/UpgradePotions/Nodes/upgrade_potion.tscn")

@onready var _sprite: Sprite2D = %Sprite2D
@export var _upgrade_potion_resource: UpgradePotionResource
@export var _target: String = "player"

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

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(_target):
		return
	
	var body_apply_effect_component: ApplyEffectComponent = GameManager.find_apply_effect_component(body)
	
	if not body_apply_effect_component:
		push_error("UpgradePotion: cannot find ApplyEffectComponent from " + body.to_string() + ". cannot apply effect to this body.")
		return
	
	if body_apply_effect_component.apply_effect(_upgrade_potion_resource):
		queue_free()
