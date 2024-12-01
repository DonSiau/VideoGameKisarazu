extends AnimatableBody2D

var tweenShake = create_tween()

func _on_area_2d_area_entered(area: Area2D) -> void:
    $dropTimer.start()
    var tweenShake = create_tween()

    tweenShake.tween_property(self, "position:y", position.y + 4, 0.8)




func _on_drop_timer_timeout() -> void:
    var tweenDrop = create_tween()
    tweenDrop.tween_property(self, "position:y", position.y + 4000, 10.0)
