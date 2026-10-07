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
var current_pan_direction: Vector2 = Vector2.ZERO
var t = 0.0
var waiting_t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var new_pan_direction: Vector2 = get_pan_direction(mouse_pos)
	
	if new_pan_direction != current_pan_direction:
		if waiting_t >= delay_before_lerp:
			t = 0.0
			current_pan_direction = new_pan_direction
			previous_offset = current_offset
		else: 
			waiting_t += delta
	else:
		waiting_t = 0.0
		
	if t < 1.0:
		t += delta / time_to_lerp
		var to: Vector2 = Vector2(current_pan_direction.x * max_offset_x, current_pan_direction.y * max_offset_y)
		current_offset = previous_offset.lerp(to, min(t, 1))
		
	offset = current_offset

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
