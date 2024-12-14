extends Node2D
@onready var player: CharacterBody2D = $player

func _ready():
    player.is_depowered=true
