extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player
@onready var player = get_parent().get_node("player")  # Reference to the Player node
@export var health: float = 220
var SPEED = 35

@onready var killzone: Area2D = $killzone


var is_following=true
var is_moveAttack=false
var is_teleporting=false
var is_charging_slice=false

@export var phase = 1
var attackCount=1 #used to track attack order within a phase
@onready var follow_player_p_1: Timer = $followPlayerP1
@onready var move_attack_p_1: Timer = $moveAttackP1
@onready var slice: Timer = $slice

var phase2Started=true
@onready var sliceShape: CollisionShape2D = $killzone/SliceShape






#initial plan. The attack pattern will cycle as seen in the numberings
#Phase1:
#1.follows player. every 5 seconds, he becomes temporarily faster, using the slash attack.
#2.teleports to static portions of the map, shooting projectiles statically.
#Phase2:
#1. follows player. every 5 seconds, he becomes temporarily faster, using the slash attack.
#2. uses the larger AOE slash attack
#3. teleports to static portions of the map, shooting projectiles statically.
#Phase3:
#1. follows player. every 5 seconds, he becomes temporarily faster, using the slash attack.
#2. uses the larger AOE slash attack
#3. teleports to static portions of the map, shooting projectiles statically.
#4. Uses the ariel slice attack
@onready var teleport: Timer = $teleport



func _ready() -> void:
        follow_player_p_1.start()
        animated_sprite_2d.scale = Vector2(1, 1)
        var shader_material = ShaderMaterial.new()
        shader_material.shader = preload("res://shader/flashShader.gdshader")
        shader_material.set_shader_parameter("active", false)
        animated_sprite_2d.material = shader_material
        animated_sprite_2d.play("move")

func _process(delta: float) -> void:
    if player and is_following and !is_teleporting and !is_charging_slice:  #
     player_pos = player.position  # Get the player's position
     target_pos = (player_pos - position).normalized()  # Calculate the direction towards the player
     animated_sprite_2d.flip_h = target_pos.x < 0
     if is_moveAttack:
        if !is_teleporting:
         animated_sprite_2d.play("move_attack")
         SPEED=55
     else:
        if !is_teleporting:
         animated_sprite_2d.play("move")
         SPEED=35


    if position.distance_to(player_pos) <500:
     position += target_pos * SPEED * delta  # Update the position manually based on speed and delta

    if health < 170:
     phase = 3
    elif health < 80:
     phase = 2
    if phase==1:
     pass;
func start_slice_attack():
 if !is_charging_slice:
  is_charging_slice=true
  animated_sprite_2d.play("stop_move_attack")
  await animated_sprite_2d.animation_finished
  animated_sprite_2d.play("idle")
  SPEED=0
  follow_player_p_1.stop()  # Stop the follow timer
  move_attack_p_1.stop()    # Stop the attack timer
  slice.start()


func start_teleport():
    is_teleporting=true
    SPEED=0
    follow_player_p_1.stop()
    move_attack_p_1.stop()
    animated_sprite_2d.play("vanish")
    killzone.monitoring=false
    teleport.start()
func _on_follow_player_timeout() -> void:

    is_moveAttack=true
    print("start move attack")
    move_attack_p_1.start()


func _on_move_attack_timeout() -> void:

    attackCount+=1
    is_charging_slice=false
    is_moveAttack=false
    print("end move attack")
    if attackCount==2: #remember, add if phase==2
     start_slice_attack()
    elif attackCount==3:
     attackCount=0
     start_teleport()
    else:
     follow_player_p_1.start()


func _on_teleport_timeout() -> void:
    var random_x: float
    var random_y: float
    if randf() < 0.5:
     random_x = randf_range(-70, -40)
    else:
     random_x = randf_range(40, 70)
    if randf() < 0.5:
     random_y = randf_range(-70, -40)
    else:
     random_y = randf_range(40, 70)

    is_teleporting=false
    killzone.monitoring=true
    global_position = player.global_position + Vector2(random_x, random_y)
    follow_player_p_1.start()


func _on_slice_timeout() -> void:
    animated_sprite_2d.play("slice_attack")
    await get_tree().create_timer(0.1).timeout
    sliceShape.disabled=false
    await animated_sprite_2d.animation_finished
    sliceShape.disabled=true
    is_charging_slice=false
    follow_player_p_1.start()
