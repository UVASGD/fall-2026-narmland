extends Camera2D

# Maximum offset allowed when panning the camera
@export var max_offset: Vector2 = Vector2(100, 75)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(get_viewport().get_mouse_position())
