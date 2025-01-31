extends Node

class_name Damageable
@onready var audio_stream_player_damaged: AudioStreamPlayer2D = $AudioStreamPlayer_Damaged
@onready var boss_health_bar: TextureProgressBar = $"../CanvasLayerHealth/BossHealthBar"
@onready var heart_hoarder: CharacterBody2D = $".."

func set_healthBar() -> void:
    boss_health_bar.value = max(heart_hoarder.health, 0)
func hit(damage: int):
    var parent = get_parent()
    parent.health -= damage
    audio_stream_player_damaged.play()
    if parent.has_node("Flash"):
     var anim_player = parent.get_node("Flash")
     anim_player.play("flash")
    if parent.name=="HeartHoarder":
        set_healthBar()

    if parent.health <= 0 and !parent.name=="HeartHoarder":
        print(parent.name)
        if parent.name=="Level4Boss":
         var boss_anim_player = parent.get_parent().get_node("Level4BossFightInitator/AnimationPlayer")
         boss_anim_player.play("boss_end")
        print("Enemy is dead!")
        if parent.has_node("Flash"):
         var anim_player = parent.get_node("Flash")
         anim_player.play("flash")
         SoundManager.play_sound("death")
         parent.queue_free()
        else:
         parent.queue_free()
