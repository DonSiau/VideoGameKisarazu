extends Control

@export var pause_menu_scene: PackedScene = preload("res://scenes/menus/pauseMenu.tscn")
@export var weapon_select_scene: PackedScene = preload("res://scenes/menus/weaponSelect.tscn")
var pause_menu: Control  # Keep this as a member variable

func _ready() -> void:
    if pause_menu_scene:
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
