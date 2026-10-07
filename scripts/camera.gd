extends Camera2D

# Maximum offset allowed when panning the camera
@export var max_offset: Vector2 = Vector2(100, 75)
# Defines how far the cursor must be from the edge of the screen to trigger panning
@export var pan_zone_width: int = 100

var current_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	print(get_pan_direction(mouse_pos))

# todo could replace this with a circular hitbox, but this will do for now	
func get_pan_direction(mouse_pos: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var result: Vector2 = Vector2.ZERO
	if mouse_pos.x < pan_zone_width:
		result += Vector2(-1, 0)
	elif mouse_pos.x > viewport_size.x - pan_zone_width:
		result += Vector2(1, 0)
	if mouse_pos.y < pan_zone_width:
		result += Vector2(0, 1)
	elif mouse_pos.y > viewport_size.y - pan_zone_width:	
		result += Vector2(0, -1)
	
	return result.normalized()
