extends Node2D  # Based on Node2D
@export var health: float = 2  # Health variable defined in the enemy node
var speed = 20  # Speed of the enemy
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player

@onready var player = get_parent().get_node("player")  # Reference to the Player node

func _physics_process(delta: float) -> void:
    if player:  #
        player_pos = player.position  # Get the player's position
        target_pos = (player_pos - position).normalized()  # Calculate the direction towards the player

        if position.distance_to(player_pos) > 2:  # Only move if enemy is farther than 3 units away
            position += target_pos * speed * delta  # Update the position manually based on speed and delta
