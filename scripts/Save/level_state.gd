extends Node

var current_checkpoint: Vector2

func _ready() -> void:
    pass
func reset_checkpoint():
    #default should be -0,-15
    current_checkpoint=Vector2(-0,-15)
