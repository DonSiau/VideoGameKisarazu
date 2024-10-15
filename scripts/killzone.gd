extends Area2D
@onready var timer: Timer = $Timer

# Called when another body enters this Area2D

func _on_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player"):
    body.take_damage(1)
    if body.health<= 0:
        timer.start()


# Called when the timer times out
func _on_timer_timeout() -> void:
    get_tree().reload_current_scene()  # Reload the current scene
