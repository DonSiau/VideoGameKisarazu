extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var health: float = 100
const SPEED = 40
var attack_State ="default"

func _ready() -> void:
        animated_sprite_2d.scale = Vector2(1, 1)
        var shader_material = ShaderMaterial.new()
        shader_material.shader = preload("res://shader/flashShader.gdshader")
        shader_material.set_shader_parameter("active", false)
        animated_sprite_2d.material = shader_material
