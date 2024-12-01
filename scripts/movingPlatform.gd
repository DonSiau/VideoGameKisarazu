extends AnimatableBody2D
@onready var anim_player = $AnimationPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
    anim_player.play(self.name)
