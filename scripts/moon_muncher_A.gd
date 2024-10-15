extends Node2D  # Based on Node2D
@export var health: float = 2  # Health variable defined in the enemy node
var submerge_speed = 30
var move_speed = 250
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player
var original_y_pos: float
var difference_between_player_enemy: float
var attack_mode: bool = false
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_down_right: RayCast2D = $RaycastDownRight
@onready var raycast_down_left: RayCast2D = $RaycastDownLeft
@onready var player = get_parent().get_node("player")  # Reference to the Player node

func _ready():
    original_y_pos = global_position.y  # Store the original Y position of the enemy

func _physics_process(delta: float) -> void:
    if player:
        player_pos = player.global_position  # Get the full player position (Vector2)
        difference_between_player_enemy = abs(player.global_position.x - global_position.x)

        # Exit if the player is too far away
        if difference_between_player_enemy > 120:
            return
        # Attack mode logic
        if attack_mode:
            position.y -= submerge_speed * delta
            if global_position.y <= original_y_pos:  # condition to exit attack mode
                attack_mode = false  # Reset attack mode if needed
        else:
            var new_y_pos = original_y_pos + 20
            if global_position.y < new_y_pos:
                position.y += submerge_speed * delta  # Submerge downwards
            else:
                target_pos = (player_pos - position).normalized()  # Calculate direction towards the player
                position += target_pos * move_speed * delta  # Move horizontally towards the player

            # Check if the enemy is close enough to trigger attack mode
            if difference_between_player_enemy < 5:
                attack_mode = true  # Enter attack mode when close to the player
