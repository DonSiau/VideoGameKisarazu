extends Node

class_name Damageable

func hit(damage: int):
    var parent = get_parent()
    parent.health -= damage
    print("Hit! Damage: ", damage, " Parent Health: ", parent.health)

    if parent.health <= 0:
        print("Enemy is dead!")
        parent.queue_free()  # Remove the parent if health is 0 or less
func take_damage(damage: int):
    var parent = get_parent()
    parent.health -= damage
    print("Hit! Damage: ", damage, " Parent Health: ", parent.health)

    if parent.health <= 0:
        print("Enemy is dead!")
        parent.queue_free()  # Remove the parent if health is 0 or less
