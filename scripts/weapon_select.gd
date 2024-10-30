extends Control

@onready var Projectile = preload("res://scenes/playerProjectile.tscn")
@onready var ProjectileSpecialBomb = preload("res://scenes/playerProjectileBomb.tscn")
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    hide()

func _input(event: InputEvent):
    if event.is_action_pressed("x"):
        if visible:
            hide()
            get_tree().paused = false
        else:
            show()
            get_tree().paused = true

func _on_player_projectile_pressed() -> void:
    if player:
        player.projectileSelected = Projectile
        hide()
        get_tree().paused = false
        print("Regular projectile selected")
    else:
        print("Player reference is null")

func _on_player_projectile_bomb_pressed() -> void:
    if player:
        player.projectileSelected = ProjectileSpecialBomb
        hide()
        get_tree().paused = false
        print("Bomb projectile selected")
    else:
        print("Player reference is null")
