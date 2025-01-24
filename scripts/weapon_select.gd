extends Control

@onready var Projectile = preload("res://scenes/playerProjectile.tscn")
@onready var ProjectileSpecialBomb = preload("res://scenes/playerProjectileBomb.tscn")
@onready var ProjectileAreaBlast = preload("res://scenes/playerProjectileAreaBlast.tscn")


@onready var button_projectile =$MarginContainer/weaponsPanel/weaponsMargin/weapons/blasterContainer/playerProjectile
@onready var button_projectile_bomb = $MarginContainer/weaponsPanel/weaponsMargin/weapons/bombContainer/playerProjectileBomb
@onready var button_projectile_areaBlast = $MarginContainer/weaponsPanel/weaponsMargin/weapons/areaBlastContainer/playerProjectileAreaBlast

var default_color = Color(1, 1, 1) # White or original color
var selected_color = Color(1, 0.5, 0) # Orange
var selected_button = null # Initially no button is selected
func get_player():
    return get_tree().get_first_node_in_group("Player")
func _ready() -> void:

    process_mode = Node.PROCESS_MODE_ALWAYS
    if SaveState.save_dict["playerProjectileBombUnlocked"]==false:
        $MarginContainer/weaponsPanel/weaponsMargin/weapons/bombContainer.visible=false
    if SaveState.save_dict["playerProjectileAreaBlastUnlocked"]==false:
        $MarginContainer/weaponsPanel/weaponsMargin/weapons/areaBlastContainer.visible=false

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
    var player=get_player()
    if selected_button:
        selected_button.modulate = default_color
    selected_button = button
    selected_button.modulate = selected_color


func _on_player_projectile_bomb_pressed() -> void:
    var player=get_player()
    if player:
        player.projectileSelected = ProjectileSpecialBomb
        player.currentWeapon="bombProjectile"
        get_tree().paused = false
        select_button(button_projectile_bomb)
        hide()

func _on_player_projectile_pressed() -> void:
     var player=get_player()
     if player:
        player.projectileSelected = Projectile
        player.currentWeapon="projectile"
        get_tree().paused = false
        select_button(button_projectile)
        hide()

func _on_player_projectile_area_blast_pressed() -> void:
     var player=get_player()
     if player:
        player.projectileSelected = ProjectileAreaBlast
        player.currentWeapon="areaBlastProjectile"
        get_tree().paused = false
        select_button(button_projectile_areaBlast)
        hide()
