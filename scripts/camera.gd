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
# Once we've panned, the zone defined earlier gets bigger, and only once we're out of that zone allow panning back
@export var pan_return_zone_width: int = 200
var previous_pan_direction: Vector2 = Vector2.ZERO

# Arbitrary values that determines how fast the camera will lerp to a new position
@export var lerp_delta = 2

var narm_leg_grabbed: bool = false
var narm_visible: bool = true
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
	
	# If narm is not visible on screen start tracking
	if not narm_visible:
		status = Status.TRACKING_NARM
	# Check if we should now anchor - if narm leg grabbed or there is a pan direction
	elif narm_leg_grabbed or new_pan_direction != Vector2.ZERO:
		status = Status.ANCHORED
	else:
		status = Status.TRACKING_NARM
	
	
	# follow narm
	if status == Status.TRACKING_NARM:
		offset = lerp(offset, Vector2.ZERO, lerp_delta * delta)
		var new_global_position = lerp(global_position, narm.global_position, lerp_delta * delta)
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
	var zone_width = pan_zone_width
	if previous_pan_direction != Vector2.ZERO:
		zone_width = pan_return_zone_width
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var result: Vector2 = Vector2.ZERO
	if mouse_pos.x < zone_width:
		result += Vector2(-1, 0)
	elif mouse_pos.x > viewport_size.x - zone_width:
		result += Vector2(1, 0)
	if mouse_pos.y < zone_width:
		result += Vector2(0, -1)
	elif mouse_pos.y > viewport_size.y - zone_width:	
		result += Vector2(0, 1)
	
	previous_pan_direction = result
	return result
	


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	narm_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	narm_visible = false
