extends Node2D
@export var health: float = 6  # Health variable defined in the enemy node
var SPEED = 20  # Speed of the enemy
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("player")  # Reference to the Player node
func _ready() -> void:

        var shader_material = ShaderMaterial.new()
        shader_material.shader = preload("res://shader/flashShader.gdshader")
        shader_material.set_shader_parameter("active", false)
        animated_sprite_2d.material = shader_material
func _physics_process(delta: float) -> void:
    if player:  #
        player_pos = player.position  # Get the player's position
        target_pos = (player_pos - position).normalized()  # Calculate the direction towards the player

        if position.distance_to(player_pos) <160:
            position += target_pos * SPEED * delta  # Update the position manually based on speed and delta
