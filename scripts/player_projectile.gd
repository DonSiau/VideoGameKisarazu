extends Area2D
@onready var projectile_timeout = $Projectile_timeout
@export var damage: int = 1
const MOVE_SPEED = 180
var velocity = Vector2.ZERO

func launch(direction: Vector2):
    velocity = direction
    $Projectile_timeout.start()


func _physics_process(delta: float) -> void:
    position += velocity * MOVE_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    print("Body entered: ", body.name)
    for child in body.get_children():
        if child is Damageable:
            child.hit(damage)
            queue_free()
        else:

            print("No Damageable node found")


func _on_projectile_timeout_timeout() -> void:
        queue_free()
