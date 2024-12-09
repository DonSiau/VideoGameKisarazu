extends AnimatableBody2D








func _on_drop_timer_timeout() -> void:
    var tweenDrop = create_tween()
    tweenDrop.tween_property(self, "position:y", position.y + 4000, 10.0)


func _on_area_2d_body_entered(body: Node2D) -> void:
    print("yepee")
    if body.is_in_group("Player"):
     $dropTimer.start()
     var tweenShake = create_tween()
     tweenShake.tween_property(self, "position:y", position.y + 4, 0.8)
