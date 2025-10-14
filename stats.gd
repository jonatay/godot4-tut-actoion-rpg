class_name Stats extends Resource

@export var health : int = 1:
    set(value):
        var old_health = health
        health = value
        if health <= 0:
            health = 0
            no_health.emit()
        if health != old_health:
            health_changed.emit(health)

@export var max_health : int = 1

signal health_changed(new_health: int)
signal no_health()