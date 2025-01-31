extends DialogicBackground

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    Dialogic.signal_event.connect(DialogicSignal)



func DialogicSignal(argument: String):
    if argument == "cutscene1":
        print("Signal Received")
        animation_player.play("cutscene1")
