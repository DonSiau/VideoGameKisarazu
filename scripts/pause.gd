extends Control

@onready var pause_menu: Control = $PauseMenu  # If you add it directly to the scene
# Or keep your packed scene
@export var pause_menu_scene: PackedScene = preload("res://scenes/menus/pauseMenu.tscn")

func _ready() -> void:
    # If using packed scene, instantiate it right away and hide it
    if pause_menu_scene and not pause_menu:
        pause_menu = pause_menu_scene.instantiate()
        pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
        add_child(pause_menu)
        pause_menu.hide()

func _on_pause_pressed() -> void:
    print("Pause button pressed")
    get_tree().paused = true
    if pause_menu:
        pause_menu.show()
        print("Showing pause menu")
    else:
        print("Error: Pause menu not found!")
