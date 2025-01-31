extends DialogicBackground
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_4: Node2D = $Control/MarginContainer/cutscene4
@onready var camera_2d: Camera2D = $Control/MarginContainer/cutscene4/Camera2D


@onready var player = get_node("player")

func _ready() -> void:
    Dialogic.signal_event.connect(DialogicSignal)
    start_dialog()

func start_dialog():
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start("Level3Outro")


func _on_timeline_ended():
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")


func DialogicSignal(argument: String):
    if argument == "cutscene1":
        print("Signal Received")
        animation_player.play("cutscene1")
    if argument == "cutscene2":
        animation_player.play("cutscene2")
    if argument == "cutscene3":
        animation_player.play("cutscene3")
    if argument == "cutscene4":
        animation_player.play("cutscene4")
    if argument=="cutscene5":
        animation_player.play("cutscene5")
