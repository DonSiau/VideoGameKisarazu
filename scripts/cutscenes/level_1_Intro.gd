extends Node2D
@onready var player = get_node("player")
func _ready() -> void:
    start_dialog()
func start_dialog():
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start("Level1Intro")

func _on_timeline_ended():
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
