extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var initiated=false
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player") and  not initiated:
        initiated=true
        body.is_depowered=false
        print("entered")
        animation_player.play("boss initiation")
