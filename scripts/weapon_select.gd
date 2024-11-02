extends Control

@onready var Projectile = preload("res://scenes/playerProjectile.tscn")
@onready var ProjectileSpecialBomb = preload("res://scenes/playerProjectileBomb.tscn")
@onready var player = get_tree().get_first_node_in_group("Player")

@onready var button_projectile =$MarginContainer/weaponsPanel/weaponsMargin/weapons/blasterContainer/playerProjectile
@onready var button_projectile_bomb = $MarginContainer/weaponsPanel/weaponsMargin/weapons/bombContainer/playerProjectileBomb

var default_color = Color(1, 1, 1) # White or original color
var selected_color = Color(1, 0.5, 0) # Orange
var selected_button = null # Initially no button is selected

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    hide()
    select_button(button_projectile)  #

func _input(event: InputEvent):
    if event.is_action_pressed("x"):
        if visible:
            hide()
            get_tree().paused = false
        else:
            show()
            get_tree().paused = true


func select_button(button):
    if selected_button:
        selected_button.modulate = default_color
    selected_button = button
    selected_button.modulate = selected_color


func _on_player_projectile_bomb_pressed() -> void:
    if player:
        player.projectileSelected = ProjectileSpecialBomb
        get_tree().paused = false
        select_button(button_projectile_bomb)
        hide()




func _on_player_projectile_pressed() -> void:
     if player:
        player.projectileSelected = Projectile
        get_tree().paused = false
        select_button(button_projectile)
        hide()
