extends Node2D
var checkpoint_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
 pass;



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass






func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):

     LevelState.current_checkpoint=global_position
     print("entered checkpoint at: "+ str(global_position))
     print("the player node says: "+str(LevelState.current_checkpoint))
