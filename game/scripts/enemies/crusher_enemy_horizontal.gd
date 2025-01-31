extends Node2D

const SPEED = 40
@export var CRUSH_SPEED = 150
@export var direction = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down: RayCast2D = $RaycastDown

@export var attack_timer_offset: float = 3.0
@onready var attack_timer: Timer = $attackTimer

@export var attack_warn_offset: float = 8.0
@onready var attack_warn: Timer = $attackWarn

var original_x_pos: float
var attack_mode: bool = false
var return_mode: bool = false
var is_at_right: bool = false
var is_at_left: bool =true
func _ready() -> void:
    attack_timer.wait_time=attack_timer_offset
    attack_warn.wait_time=attack_warn_offset
    direction=1
    animated_sprite_2d.scale = Vector2(1, 1)
    original_x_pos = global_position.x

func _process(delta: float) -> void:
    if attack_mode:
        position.x += direction * CRUSH_SPEED * delta
    if raycast_right.is_colliding() and direction==1:
            direction=-1
            animated_sprite_2d.play("crusher_attack_left")
            attack_mode = false
            $attackTimer.start()
    elif raycast_left.is_colliding() and direction==-1:
            direction=1
            animated_sprite_2d.play("crusher_attack_right")
            attack_mode = false
            $attackTimer.start()





func _on_attack_timer_timeout() -> void:
    attack_mode = true
