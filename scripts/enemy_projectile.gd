extends Area2D
@export var damage: int = 1

const MOVE_SPEED = 120
var velocity = Vector2.ZERO

func launch(direction: Vector2):
    velocity = direction
    $Projectile_timeout.start()



func _physics_process(delta: float) -> void:
    position += velocity * MOVE_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    print("Body entered: ", body.name)
    if body.is_in_group("Player"):
     body.take_damage(1)
     if body.health<= 0:
        $Timer.start()

# Called when the timer finishes (triggered by the timer's timeout signal)
func _on_timer_timeout() -> void:
    get_tree().reload_current_scene()



func _on_projectile_timeout_timeout() -> void:
        queue_free()
