class_name Bullet extends Area2D

const BULLET_SCENE: PackedScene = preload("res://Entities/Objects/Bullet/Node/bullet.tscn")

var _bullet_speed: float = 500.0
var _bullet_direction: Vector2 = Vector2.LEFT:
	set(direction):
		_bullet_direction = direction
		_bullet_direction = _bullet_direction.normalized()
		rotation = atan2(-_bullet_direction.y, -_bullet_direction.x)

var _bullet_damage: int = 1

var _bullet_knockback_force: float
var _bullet_knockback_decerlation: float

var _target: String


static func new_bullet(damage: int, speed: float, knockback_force: float, knockback_decerlation: float, pos: Vector2, direction: Vector2, b_scale: Vector2, target: String = "player") -> Bullet:
	var bullet := BULLET_SCENE.instantiate() as Bullet
	bullet._bullet_damage = damage
	bullet._bullet_speed = speed
	bullet._bullet_knockback_force = knockback_force
	bullet._bullet_knockback_decerlation = knockback_decerlation
	bullet.global_position = pos
	bullet._bullet_direction = direction
	bullet.scale = b_scale
	bullet._target = target
	return bullet

func _physics_process(delta: float) -> void:
	position += _bullet_speed * _bullet_direction * delta

func _on_bullet_hit(body: Node2D) -> void:
	if body.is_in_group(_target):
		var body_health_component: HealthComponent = GameManager.find_health_component(body)
		var body_knockback_component: KnockbackComponent = GameManager.find_knockback_component(body)
		
		if body_health_component:
			body_health_component.take_damage(_bullet_damage)
		if body_knockback_component:
			var knockback_direction: Vector2 = global_position.direction_to(body.global_position)
			body_knockback_component.do_knockback(knockback_direction, _bullet_knockback_force, _bullet_knockback_decerlation)
	
		call_deferred("queue_free")
