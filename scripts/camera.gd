extends Camera2D

@onready var narm: Node2D = get_parent()

enum Status {
	TRACKING_NARM,
	ANCHORED
}

# Maximum offset allowed when panning the camera
@export var pan_offset_x: float = 200
@export var pan_offset_y: float = 200
# Defines how far the cursor must be from the edge of the screen to trigger panning
@export var pan_zone_width: int = 100

# Arbitrary values that determines how fast the camera will lerp to a new position
@export var lerp_delta = 2
@export var tracking_lerp_delta = 10

var narm_leg_grabbed: bool = false
var status: Status = Status.TRACKING_NARM


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# "Detach" the camera from the Narm so it doesn't follow its every movement
	# Instead we track the narm in the _process function, and constantly lerp to it
	top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("position: ", global_position)
	print("offset: ", offset)
	print("narm position:", narm.global_position)
	print("status: ", status)
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var new_pan_direction: Vector2 = get_pan_direction(mouse_pos)
	
	# Check if we should now anchor - if narm leg grabbed or there is a pan direction
	if narm_leg_grabbed or new_pan_direction != Vector2.ZERO:
		status = Status.ANCHORED
	else:
		status = Status.TRACKING_NARM
	
	
	# follow narm
	if status == Status.TRACKING_NARM:
		offset = lerp(offset, Vector2.ZERO, lerp_delta * delta)
		var new_global_position = lerp(global_position, narm.global_position, tracking_lerp_delta * delta)
		global_position = new_global_position
	
	# do not move global position, only move offset	
	elif status == Status.ANCHORED:
		var new_offset = lerp(offset, 
		Vector2(new_pan_direction.x * pan_offset_x, new_pan_direction.y * pan_offset_y), lerp_delta * delta)
		offset = new_offset
			
	
		
		
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
	
