extends Area2D
@export var damage: int = 1
const MOVE_SPEED = 120
var velocity = Vector2.ZERO
var should_reload = false

func launch(direction: Vector2):
    velocity = direction
    $Projectile_timeout.start()

func _physics_process(delta: float) -> void:
    position += velocity * MOVE_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        body.take_damage(1)
        print("took damage")
        print(body.health)

        if body.health <= 0:
            should_reload = true
            $deathTimer.start()

        if !should_reload:
            queue_free()

func _on_projectile_timeout_timeout() -> void:
    if !should_reload:
        queue_free()

func _on_death_timer_timeout() -> void:
    print("test")
    get_tree().reload_current_scene()
