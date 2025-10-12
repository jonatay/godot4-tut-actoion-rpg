class_name Hurtbox extends Area2D

signal hurt(hitbox:Hitbox)


func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is not Hitbox:
		return
	# emit_signal("hurt", area as Hitbox)
	hurt.emit(area as Hitbox)
