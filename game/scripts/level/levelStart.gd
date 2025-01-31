extends Node2D

func _ready():
    var tween = create_tween();
    process_mode = Node.PROCESS_MODE_ALWAYS
    get_tree().paused = true
    set_process_input(false)
    set_process_unhandled_input(false)

    tween.tween_property($LevelStart, "offset", Vector2(500,0), 5)
    tween.tween_property($LevelStart, "offset", Vector2(866,0), 0.7)
    tween.tween_property($LevelStart, "offset", Vector2(1932,0), 0.25)
    tween.finished.connect(func():
        set_process_input(true)
        set_process_unhandled_input(true)
        get_tree().paused = false

        )
