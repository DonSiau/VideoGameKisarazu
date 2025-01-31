extends Node2D
@export var speed=10
@export var direction=1
func _physics_process(delta: float) -> void:
        for child in get_children():
            if child.name!="Sprite2D":
             child.rotation_degrees+=speed*direction*delta
