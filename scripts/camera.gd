extends Camera2D

# Maximum offset allowed when panning the camera
@export var max_offset_x: float = 200
@export var max_offset_y: float = 200
# Defines how far the cursor must be from the edge of the screen to trigger panning
@export var pan_zone_width: int = 100
@export var time_to_lerp: float = 1.0
@export var delay_before_lerp: float = 1.0

var current_offset: Vector2 = Vector2.ZERO
var previous_offset: Vector2 = Vector2.ZERO
var global_anchor: Vector2 = Vector2.ZERO
var current_pan_direction: Vector2 = Vector2.ZERO
var t: float = 0.0
var waiting_t: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var new_pan_direction: Vector2 = get_pan_direction(mouse_pos)

	if new_pan_direction != current_pan_direction:
		if waiting_t < delay_before_lerp:
			waiting_t += delta
			return
	else:
		waiting_t = 0.0
	
	if new_pan_direction != Vector2.ZERO:
		pan_to(new_pan_direction, delta)
	else:
		pan_back()
		
	

# todo could replace this with a circular hitbox, but this will do for now	
func get_pan_direction(mouse_pos: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var result: Vector2 = Vector2.ZERO
	if mouse_pos.x < pan_zone_width:
		result += Vector2(-1, 0)
	elif mouse_pos.x > viewport_size.x - pan_zone_width:
		result += Vector2(1, 0)
	if mouse_pos.y < pan_zone_width:
		result += Vector2(0, -1)
	elif mouse_pos.y > viewport_size.y - pan_zone_width:	
		result += Vector2(0, 1)
	
	return result
	
func pan_to(new_pan_direction: Vector2, delta: float):
	if new_pan_direction != current_pan_direction:
		global_anchor = global_position
		top_level = true
		global_position = global_anchor
		
		t = 0.0
		current_pan_direction = new_pan_direction
		previous_offset = current_offset
		
	if t < 1.0:
		t += delta / time_to_lerp
		var to: Vector2 = Vector2(current_pan_direction.x * max_offset_x, current_pan_direction.y * max_offset_y)
		current_offset = previous_offset.lerp(to, min(t, 1))

	offset = current_offset
	
func pan_back():
	top_level = false
	position = Vector2.ZERO
	offset = Vector2.ZERO
	t = 0.0
	waiting_t = 0.0
	previous_offset = Vector2.ZERO
	current_offset = Vector2.ZERO
	current_pan_direction = Vector2.ZERO
