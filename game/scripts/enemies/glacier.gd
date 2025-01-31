extends Node2D

var SPEED = 170
var falling: bool = false

func _process(delta: float) -> void:
    if $attackCast.is_colliding():
        var collider = $attackCast.get_collider()  #
        if collider and collider.name == "player" and !falling:
            falling = true
    if falling:
        position.y += SPEED * delta
