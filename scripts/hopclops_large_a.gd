extends Node2D

const SPEED = 40
var direction = 1
@export var health: float = 3  # Health variable defined in the enemy node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down_right: RayCast2D = $RaycastDownRight
@onready var raycast_down_left: RayCast2D = $RaycastDownLeft

# Jump variables
var is_jumping = false
var jump_height = 55
var jump_width = 25
var jump_duration = 1.0
var jump_timer = 0.0

func _ready():
    $jumpTimer.connect("timeout", Callable(self, "_on_jump_timer_timeout"))
    $jumpTimer.start()
    # Ensure the sprite's scale is set to (1, 1) initially
    animated_sprite_2d.scale = Vector2(1, 1)

func _on_jump_timer_timeout():
    if not is_jumping:
        is_jumping = true
        jump_timer = 0.0

func _process(delta: float) -> void:
    if is_jumping:
        jump_timer += delta
        var jump_progress = jump_timer / jump_duration

        if jump_progress < 0.5:
            # Moving up and forward
            animated_sprite_2d.play("Hoclops_large_A_jump")
            position.y -= jump_height * 2 * delta
            position.x += direction * jump_width * 2 * delta
        elif jump_progress < 1.0:
            # Moving down and forward
            animated_sprite_2d.play("Hoclops_large_A_fall")
            position.y += jump_height * 2 * delta
            position.x += direction * jump_width * 2 * delta
        else:
            # Jump complete
            is_jumping = false
            print("Jump completed")
    else:
        animated_sprite_2d.play("Hoclops_large_A_move")
        # Existing movement code
        if raycast_right.is_colliding():
            direction = -1
            animated_sprite_2d.flip_h = true
        elif raycast_left.is_colliding():
            direction = 1
            animated_sprite_2d.flip_h = false

        if direction == 1 and not raycast_down_right.is_colliding():
            direction = -1
            animated_sprite_2d.flip_h = true
        elif direction == -1 and not raycast_down_left.is_colliding():
            direction = 1
            animated_sprite_2d.flip_h = false

        position.x += direction * SPEED * delta
