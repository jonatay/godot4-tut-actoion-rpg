class_name Hurtbox extends Area2D

signal hurt(hitbox:Hitbox)


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D) -> void:
	if other_area is not Hitbox:
		return
	var other_hitbox = other_area as Hitbox
	if self in other_hitbox.hit_targets:
		return
	if other_hitbox.stores_hit_targets:
		other_hitbox.hit_targets.append(self)
	hurt.emit(other_hitbox)
