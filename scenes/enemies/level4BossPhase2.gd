extends Node2D
@export var speed=30
func _physics_process(delta: float) -> void:
        for child in get_children():
            child.rotation_degrees+=speed*delta
