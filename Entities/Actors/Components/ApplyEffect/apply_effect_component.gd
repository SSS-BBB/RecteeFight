class_name ApplyEffectComponent extends Node2D

@export var _health_component: HealthComponent # current health, max health
@export var _player_control: PlayerControl # speed
@export var _melee_attack_component: MeleeAttackComponent # attck speed, damage
@export var _pick_up_audio_player: AudioStreamPlayer2D

signal effect_applied

func apply_effect(upgrade_resource: UpgradePotionResource) -> bool:
	var applied_successfully: bool = false
	match upgrade_resource.effect:
		UpgradePotionResource.Effect.CURRENT_HEALTH:
			applied_successfully = _upgrade_current_health(upgrade_resource.value_i)
		UpgradePotionResource.Effect.MAX_HEALTH:
			applied_successfully = _upgrade_max_health(upgrade_resource.value_i)
		UpgradePotionResource.Effect.SPEED:
			applied_successfully = _upgrade_speed(upgrade_resource.value_f)
		UpgradePotionResource.Effect.ATTACK_SPEED:
			applied_successfully = _upgrade_attack_speed(upgrade_resource.value_f)
		UpgradePotionResource.Effect.DAMAGE:
			applied_successfully = _upgrade_attack_damage(upgrade_resource.value_i)
		_:
			push_error("ApplyEffectComponent: effect " + str(upgrade_resource.effect) + " is not implemented yet.")
	
	if applied_successfully:
		if _pick_up_audio_player:
			_pick_up_audio_player.stream = upgrade_resource.get_audio
			_pick_up_audio_player.play()
		else:
			push_warning("ApplyEffectComponent: _pick_up_audio_player is not initialized. cannot play audio when pick up an upgrade potion.")
		
		effect_applied.emit()
		
	return applied_successfully

func _upgrade_current_health(value: int) -> bool:
	if not _health_component:
		push_error("ApplyEffectComponent: _health_component is not initialized. cannot upgrade current health.")
		return false
	return _health_component.gain_health(value)

func _upgrade_max_health(value: int) -> bool:
	if not _health_component:
		push_error("ApplyEffectComponent: _health_component is not initialized. cannot upgrade max health.")
		return false
	return _health_component.update_max_health(value)

func _upgrade_speed(value: float) -> bool:
	if not _player_control:
		push_error("ApplyEffectComponent: _player_control is not initialized. cannot upgrade speed.")
		return false
	return _player_control.upgrade_speed(value)

func _upgrade_attack_speed(value: float) -> bool:
	if not _melee_attack_component:
		push_error("ApplyEffectComponent: _melee_attack_component is not initialized. cannot upgrade attack speed.")
		return false
	return _melee_attack_component.upgrade_attack_speed(value)

func _upgrade_attack_damage(value: int) -> bool:
	if not _melee_attack_component:
		push_error("ApplyEffectComponent: _melee_attack_component is not initialized. cannot upgrade attack damage.")
		return false
	return _melee_attack_component.upgrade_damage(value)
