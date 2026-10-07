extends Camera2D

# Maximum offset allowed when panning the camera
@export var max_offset_x: float = 200
@export var max_offset_y: float = 200
# Defines how far the cursor must be from the edge of the screen to trigger panning
@export var pan_zone_width: int = 100
@export var time_to_lerp: float = 1.0
@export var delay_before_lerp: float = 1.0

enum PanStatus {
	FOLLOWING_NARM,
	PANNING,
	STILL,
	PANNING_BACK
}

var narm_leg_grabbed: bool = false
var current_offset: Vector2 = Vector2.ZERO
var previous_offset: Vector2 = Vector2.ZERO
var global_anchor: Vector2 = Vector2.ZERO
var current_pan_direction: Vector2 = Vector2.ZERO
var t: float = 0.0
var waiting_t: float = 0.0

var pan_status: PanStatus = PanStatus.FOLLOWING_NARM
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("pan status: ", pan_status)
	print("top level status: ", top_level)
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var new_pan_direction: Vector2 = get_pan_direction(mouse_pos)
	
	var wait_done = waiting_t >= delay_before_lerp
	waiting_t += delta
	
	# not holding narm
	if not narm_leg_grabbed:
		if pan_status == PanStatus.FOLLOWING_NARM and new_pan_direction != Vector2.ZERO and wait_done:
			waiting_t = 0.0
			t = 0.0
			current_pan_direction = new_pan_direction
			stop_following_narm()
			pan_status = PanStatus.PANNING
		elif pan_status == PanStatus.STILL and new_pan_direction != current_pan_direction and wait_done:
			waiting_t = 0.0
			t = 0.0
			current_pan_direction = new_pan_direction
			pan_status = PanStatus.PANNING
		elif pan_status == PanStatus.STILL and new_pan_direction == Vector2.ZERO and wait_done:
			waiting_t = 0.0
			t = 0.0
			current_pan_direction = new_pan_direction
			pan_status = PanStatus.PANNING_BACK
		
	# holding narm	
	else:
		stop_following_narm()
		pan_status = PanStatus.STILL
		if new_pan_direction != current_pan_direction and wait_done:
			waiting_t = 0.0
			t = 0.0
			current_pan_direction = new_pan_direction
			pan_status = PanStatus.PANNING
			
	if pan_status == PanStatus.FOLLOWING_NARM:
		snap_follow_narm()
	elif pan_status == PanStatus.PANNING:
		stop_following_narm()
		pan_to(delta)
	elif pan_status == PanStatus.STILL:
		pass
	elif pan_status == PanStatus.PANNING_BACK:
		pan_back_to_narm(delta)
			
	
		
		
func on_narm_grab(narm_leg: NarmLeg):
	narm_leg_grabbed = true
	
func on_narm_release(narm_leg: NarmLeg):
	narm_leg_grabbed = false
		
	

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
	
func pan_to(delta: float):
	# if different pan direction, start lerping from current offset and reset both time counters
	if t < 1.0:
		t += delta / time_to_lerp
		var to: Vector2 = Vector2(current_pan_direction.x * max_offset_x, current_pan_direction.y * max_offset_y)
		current_offset = previous_offset.lerp(to, min(t, 1))
	else:
		pan_status = PanStatus.STILL
	offset = current_offset
	
func pan_back_to_narm(delta: float):
	var narm: Node2D = get_parent()
	var target_offset: Vector2 = global_anchor - narm.global_position
	if t < 1.0:
		t += delta / time_to_lerp
		current_offset = previous_offset.lerp(target_offset, min(t, 1))
	else:
		snap_follow_narm()
		pan_status = PanStatus.FOLLOWING_NARM
	offset = current_offset
	
func stop_following_narm():
	if top_level: return
	global_anchor = global_position
	top_level = true
	global_position = global_anchor
	
func snap_follow_narm():
	if not top_level: return
	top_level = false
	position = Vector2.ZERO
	current_offset = Vector2.ZERO
	offset = current_offset
