extends Node

class_name Damageable

func hit(damage: int):
    var parent = get_parent()
    parent.health -= damage
    if parent.has_node("Flash"):
     var anim_player = parent.get_node("Flash")
     anim_player.play("flash")

    if parent.health <= 0:
        print("Enemy is dead!")
        if parent.has_node("Flash"):
         var anim_player = parent.get_node("Flash")
         anim_player.play("flash")
        parent.queue_free()  # Remove the parent if health is 0 or less

func take_damage(damage: int):
    var parent = get_parent()
    parent.health -= damage
    var anim_player = parent.get_node("AnimationPlayer")
    anim_player.play("flash")
    print("Hit! Damage: ", damage, " Parent Health: ", parent.health)

    if parent.health <= 0:
        print("Enemy is dead!")
        parent.queue_free()  # Remove the parent if health is 0 or less
