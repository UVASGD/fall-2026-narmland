extends Camera2D

# Maximum offset allowed when panning the camera
@export var max_offset_x: float = 200
@export var max_offset_y: float = 200
# Defines how far the cursor must be from the edge of the screen to trigger panning
@export var pan_zone_width: int = 100
@export var time_to_lerp: float = 1.0
@export var delay_before_lerp: float = 1.0
@export var lerp_delta = 2

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
var t: float         = 0.0
var waiting_t: float = 0.0
@onready var narm: Node2D = get_parent()

var pan_status: PanStatus = PanStatus.FOLLOWING_NARM
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("position: ", global_position)
	print("narm position:", narm.global_position)
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var new_pan_direction: Vector2 = get_pan_direction(mouse_pos)
	
	var wait_done = waiting_t >= delay_before_lerp
	waiting_t += delta
	
	# follow narm
	var new_global_position = lerp(global_position, narm.global_position, lerp_delta * delta)
	global_position = new_global_position
#	print(distance_to_narm)
			
	
		
		
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
	global_anchor = global_position
	top_level = true
	global_position = global_anchor
	
func snap_follow_narm():
	top_level = false
	position = Vector2.ZERO
	current_offset = Vector2.ZERO
	offset = current_offset
