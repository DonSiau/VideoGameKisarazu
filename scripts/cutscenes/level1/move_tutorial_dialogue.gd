extends Node2D
var read=false;
var node_name = self.name

#make sure name of timeline and name of the node is the same
func _on_area_2d_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player") and !read:
    Dialogic.play(node_name)
    read=true;
