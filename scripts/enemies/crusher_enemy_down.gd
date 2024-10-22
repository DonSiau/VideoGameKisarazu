extends Node2D

const SPEED = 40
const CRUSH_SPEED = 200
var direction = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down: RayCast2D = $RaycastDown
var original_y_pos: float
var attack_mode: bool = false
var return_mode: bool = false

func _ready() -> void:
    animated_sprite_2d.scale = Vector2(1, 1)
    original_y_pos = global_position.y

func _process(delta: float) -> void:
    if attack_mode:
        position.y += direction * CRUSH_SPEED * delta
        if raycast_down.is_colliding():
            attack_mode = false
            return_mode = true

    elif return_mode:
        animated_sprite_2d.play("crusher_Idle")
        if position.y > original_y_pos:
            position.y -= SPEED * delta
        else:
            position.y = original_y_pos
            return_mode = false
            animated_sprite_2d.play("crusher_down_warning")
            $attackTimer.start()

func _on_attack_timer_timeout() -> void:
    attack_mode = true
