extends Node2D
@onready var area = $Area2D

var grabbed_body : RigidBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if grabbed_body != null:
		grabbed_body.global_position = global_position
func _input(e):
	if e is InputEventMouseButton:
		if e.button_index == MouseButton.MOUSE_BUTTON_LEFT and e.pressed:
			#print("debug left click detected" + str(area.global_position))
			_try_grab(area.get_overlapping_bodies())
		elif e.button_index == MouseButton.MOUSE_BUTTON_LEFT and not e.pressed:
			#print("debug release")
			grabbed_body = null
	
func _try_grab(bodies: Array[Node2D]):
	for n in bodies:
		if n is RigidBody2D and n.get_collision_layer_value(4) :
			#print("found object on layer 4 to grab")
			print("grabbed")
			grabbed_body = n;
			break
