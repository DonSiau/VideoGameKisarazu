extends Node2D
var read=false
var node_name=""
func _ready() -> void:
    if get_parent():
        node_name = self.name
    else:
        print("Warning: Parent node not found")
func _on_area_2d_body_entered(body: Node2D) -> void:
   if body.is_in_group("Player") and !read:
    print(node_name)
    Dialogic.start(str(node_name))
    read=true;
