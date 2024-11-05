extends CharacterBody2D

const SPEED = 40
const GRAVITY = 200
var direction = 1
@export var health: float = 9  # Health variable defined in the enemy node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down_right: RayCast2D = $RaycastDownRight
@onready var raycast_down_left: RayCast2D = $RaycastDownLeft
@onready var jumpPreventionLeft: RayCast2D = $JumpPreventionLeft
@onready var jumpPreventionRight: RayCast2D = $JumpPreventionRight

# Jump variables
var is_jumping = false
var jump_height = 85
var jump_width = 40
var jump_duration = 1
var jump_timer = 0.0

func _ready():
    # Shader setup
    animated_sprite_2d.scale = Vector2(1, 1)
    var shader_material = ShaderMaterial.new()
    shader_material.shader = preload("res://shader/flashShader.gdshader")
    shader_material.set_shader_parameter("active", false)
    animated_sprite_2d.material = shader_material

    # Timer setup

    $jumpTimer.start()

func _on_jump_timer_timeout():
    if not is_jumping:
        is_jumping = true
        jump_timer = 0.0

func _process(delta: float) -> void:
    if !jumpPreventionLeft.is_colliding():
        is_jumping=false
    elif !jumpPreventionRight.is_colliding():
        is_jumping=false
    if is_jumping:
        jump_timer += delta
        var jump_progress = jump_timer / jump_duration

        if jump_progress < 0.2:
            # Moving up and forward
            animated_sprite_2d.play("Hoclops_large_A_jump")
            velocity.y = -jump_height  # Apply upward velocity
            velocity.x = direction * jump_width

        elif jump_progress < 1.6:
            # Moving down and forward

            animated_sprite_2d.play("Hoclops_large_A_fall")
            velocity.y += GRAVITY * delta  # Simulate gravity during the fall
            velocity.x = direction * jump_width
        else:
            # Jump complete
            is_jumping = false
            velocity.y = 0
    else:
        animated_sprite_2d.play("Hoclops_large_A_move")
        if raycast_right.is_colliding():
            direction = -1
            animated_sprite_2d.flip_h = true
        elif raycast_left.is_colliding():
            direction = 1
            animated_sprite_2d.flip_h = false

        if direction == 1 and !raycast_down_right.is_colliding():
            direction = -1
            animated_sprite_2d.flip_h = true
        elif direction == -1 and !raycast_down_left.is_colliding():
            direction = 1
            animated_sprite_2d.flip_h = false

        velocity.x = direction * SPEED
        velocity.y += GRAVITY * delta  # Apply gravity

    # Move using velocity and handle collisions
    move_and_slide()
