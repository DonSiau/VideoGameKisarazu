extends Node2D

const SPEED = 70
var direction = 1
@export var health: float = 12  # Health variable defined in the enemy node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down_right: RayCast2D = $RaycastDownRight
@onready var raycast_down_left: RayCast2D = $RaycastDownLeft
@onready var killzone: Area2D = $"../killzone"

func _ready() -> void:
        animated_sprite_2d.scale = Vector2(1, 1)
        var shader_material = ShaderMaterial.new()
        shader_material.shader = preload("res://shader/flashShader.gdshader")
        shader_material.set_shader_parameter("active", false)
        animated_sprite_2d.material = shader_material
func _process(delta: float) -> void:

    # Check if the enemy hits a wall (left or right)
    if raycast_right.is_colliding():
        direction = -1  # Change direction to left
        animated_sprite_2d.scale.x = -1  # Flip the sprite horizontally
    elif raycast_left.is_colliding():
        direction = 1  # Change direction to right
        animated_sprite_2d.scale.x = 1  # Reset to normal orientation

    # Check for ledge detection
    if direction == 1 and not raycast_down_right.is_colliding():
        # If moving right and no ground below on the right side
        direction = -1  # Turn left
        animated_sprite_2d.scale.x = -1  # Flip sprite
    elif direction == -1 and not raycast_down_left.is_colliding():
        # If moving left and no ground below on the left side
        direction = 1  # Turn right
        animated_sprite_2d.scale.x = 1  # Reset sprite orientation

    # Move the enemy
    position.x += direction * SPEED * delta
