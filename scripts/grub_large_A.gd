extends Node2D

const SPEED = 40
var direction = 1
@export var health: float = 1 # Health variable defined in the enemy node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft


func _process(delta: float) -> void:
    if raycast_right.is_colliding():
        direction = -1
        animated_sprite_2d.scale.x = -1  # Flip the sprite horizontally
    elif raycast_left.is_colliding():
        direction = 1
        animated_sprite_2d.scale.x = 1  # Reset to normal orientation

    position.x += direction * SPEED * delta
