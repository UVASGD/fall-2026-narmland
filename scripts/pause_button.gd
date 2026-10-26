extends Button

const PAUSE_SCENE = preload("res://scenes/pause.tscn")
var pause_scene = PAUSE_SCENE.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_scene.name = "pauseScene"
	pause_scene.position = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("game paused")
	hide()
	pause_scene.show()
	get_tree().current_scene.get_node("pauseLayer").add_child(pause_scene)
	get_tree().paused = true
