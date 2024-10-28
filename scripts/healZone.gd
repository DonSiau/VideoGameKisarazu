extends Area2D

# Called when another body enters this Area2D

func _on_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player"):
    if body.health <5:
     body.gain_health(1)
     get_parent().queue_free()
