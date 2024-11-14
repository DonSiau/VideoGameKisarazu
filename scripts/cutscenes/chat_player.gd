extends Node2D
var read=false
var node_name=""
func _ready() -> void:
    if get_parent():
        node_name = get_parent().chatName
    else:
        print("Warning: Parent node not found")
func _on_area_2d_body_entered(body: Node2D) -> void:
   if body.is_in_group("Player") and !read:
    print(node_name)
    Dialogic.start(node_name)
    read=true;
