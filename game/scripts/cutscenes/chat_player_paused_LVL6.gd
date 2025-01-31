extends Node2D
var read=false
var node_name=""
@onready var heart_hoarder: CharacterBody2D = $"../HeartHoarder"
@onready var blue_portal: Node2D = $"../BluePortal"
@onready var audio_stream_player_bg: AudioStreamPlayer = $"../../AudioStreamPlayerBG"

func _ready() -> void:
    Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
    if get_parent():
        node_name = self.name
    else:
        print("Warning: Parent node not found")
func _on_area_2d_body_entered(body: Node2D) -> void:
   if body.is_in_group("Player") and !read:

    start_dialog()
    read=true;

func start_dialog():
 audio_stream_player_bg.stop()
 Dialogic.start(str(node_name)).process_mode = Node.PROCESS_MODE_ALWAYS
 Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
 Dialogic.timeline_ended.connect(_on_timeline_ended)
 get_tree().paused = true


func _on_timeline_ended():
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    heart_hoarder.visible=false
    get_tree().paused=false
