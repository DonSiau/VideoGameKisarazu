extends Node2D
@export var health: float = 9  # Health variable defined in the enemy node
var submerge_speed = 30
var SPEED = 120
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player
var original_y_pos: float
var difference_between_player_enemy: float
var attack_mode: bool = false
var at_edge: bool = false
var follow_mode: bool = false
var direction = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down_right: RayCast2D = $RaycastDownRight
@onready var raycast_down_left: RayCast2D = $RaycastDownLeft

@onready var player = get_parent().get_node("player")  # Reference to the Player node

func _ready():
      animated_sprite_2d.scale = Vector2(1, 1)
      var shader_material = ShaderMaterial.new()
      shader_material.shader = preload("res://shader/flashShader.gdshader")
      shader_material.set_shader_parameter("active", false)
      animated_sprite_2d.material = shader_material
      at_edge = false
      original_y_pos = global_position.y  # Store the original Y position of the enemy

func _physics_process(delta: float) -> void:
    # Edge detection based on raycasts
    if !raycast_down_right.is_colliding():
        direction = -1  # Change direction to left
        animated_sprite_2d.flip_h = true
        animated_sprite_2d.scale.x = -1  # Flip the sprite horizontally
        attack_mode = false
        follow_mode = false
        at_edge = true
        position.x -= 3
    elif !raycast_down_left.is_colliding():
        direction = 1  # Change direction to right
        animated_sprite_2d.flip_h = true
        animated_sprite_2d.scale.x = 1  # Reset to normal orientation
        attack_mode = false
        follow_mode = false
        at_edge = true
        position.x += 3
    else:
        at_edge = false

    if player:
        player_pos = player.global_position  # Get the full player position (Vector2)
        difference_between_player_enemy = abs(player.global_position.x - global_position.x)

        # Exit if the player is too far away or at the edge
        if difference_between_player_enemy > 120 or at_edge:
            follow_mode = false
            return
        else:
            follow_mode = true
        # Attack mode logic
        if attack_mode and !at_edge:
            position.y -= submerge_speed * delta
            if global_position.y <= original_y_pos:  # Condition to exit attack mode
                attack_mode = false  # Reset attack mode if needed
                follow_mode = true
        else:
            var new_y_pos = original_y_pos + 20
            if global_position.y < new_y_pos:
                position.y += submerge_speed * delta  # Submerge downwards
            else:
                if follow_mode == true and !at_edge:
                    target_pos = (player_pos - position).normalized()  # Calculate direction towards the player
                    position += target_pos * SPEED * delta  # Move horizontally towards the player
                    if target_pos.x > 0:

                         animated_sprite_2d.flip_h = true
                    elif target_pos.x < 0:

                          animated_sprite_2d.flip_h = false

            # Check if the enemy is close enough to trigger attack mode (only if not at edge)
            if difference_between_player_enemy < 5 and !at_edge:
                attack_mode = true  # Enter attack mode when close to the player
                follow_mode = false
