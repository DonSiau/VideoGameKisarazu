extends CharacterBody2D

var SPEED=20
func _process(delta: float) -> void:
        position.y += SPEED * delta
