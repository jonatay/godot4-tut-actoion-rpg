class_name Hurtbox extends Area2D

signal hurt(hitbox:Hitbox)


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D) -> void:
	if other_area is not Hitbox:
		return
	# emit_signal("hurt", other_area as Hitbox)
	hurt.emit(other_area as Hitbox)
