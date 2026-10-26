extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_unpause_button_pressed() -> void:
	print("game unpaused")
	var pause_scene = get_tree().current_scene.get_node("pauseScene")
	hide()
	get_tree().paused = false
	get_tree().current_scene.get_node("pauseLayer").remove_child(pause_scene)
	get_tree().current_scene.get_node("pauseLayer/pauseButton").show()
