extends Area2D
@onready var projectile_timeout = $Projectile_timeout
@export var damage: int = 3
const MOVE_SPEED = 180
var velocity = Vector2.ZERO

func launch(direction: Vector2):
    if direction == Vector2.LEFT:
        position.x+=10
    if direction == Vector2.RIGHT:
        position.x-=10
    $Projectile_timeout.start()


func _on_body_entered(body: Node2D) -> void:

    for child in body.get_children():
        if child is Damageable:
            child.hit(damage)




func _on_projectile_timeout_timeout() -> void:
        queue_free()
