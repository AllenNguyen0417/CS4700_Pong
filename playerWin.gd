extends CanvasLayer

var current_scene = null

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)		
	
func setScene(scene):
	current_scene.queue_free()
	var s = ResourceLoader.load(scene)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	
func _on_RestartButton_pressed():
	setScene("res://variant.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
