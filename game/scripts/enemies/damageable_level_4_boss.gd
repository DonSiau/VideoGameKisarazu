extends Node

class_name Damageablex
@onready var audio_stream_player_damaged: AudioStreamPlayer2D = $AudioStreamPlayer_Damaged


func hit(damage: int):
    var parent = get_parent()
    parent.health -= damage
    audio_stream_player_damaged.play()
    if parent.has_node("Flash"):
     var anim_player = parent.get_node("Flash")
     anim_player.play("flash")



    if parent.health <= 0:
        print("Enemy is dead!")
        if parent.has_node("Flash"):
         var anim_player = parent.get_node("Flash")
         anim_player.play("flash")
         SoundManager.play_sound("death")
         parent.queue_free()
        else:
         parent.queue_free()


func take_damage(damage: int):#ot used. however keep for now.

    var parent = get_parent()
    parent.health -= damage
    if parent.has_node("Flash"):
     var anim_player = parent.get_node("AnimationPlayer")
     anim_player.play("flash")

    if parent.health <= 0:
        print("Enemy is dead!")
        parent.queue_free()
