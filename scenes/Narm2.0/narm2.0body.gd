class_name Narm2
extends Node2D

@onready var foot1 : RigidBody2D = $Feet/legsegment6
@onready var foot2: RigidBody2D = $Feet/legsegment8
@onready var camera: Camera2D = $narmbody/Camera2D

signal narm_leg_grabbed(narm_leg: NarmLeg)
signal narm_leg_released(narm_leg: NarmLeg)

var rigidbody_children : Array[RigidBody2D] = []
var num_leg_one_side = 3
func _draw() -> void:
	for i in range(len(rigidbody_children) - 2):
		var child1 = rigidbody_children[i]
		var child2

		if i >= len(rigidbody_children) - 1:
			child2 = child1
		else:
			child2 = rigidbody_children[i+1]
		draw_line(child1.position, child2.position, Color.YELLOW, 20.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(500, 72)
	camera.global_position = global_position
	for child in get_children():
		if child is RigidBody2D:
			rigidbody_children.append(child)
			#if child.name.begins_with("narmbody"):
				
		if child.name.begins_with("Feet"):
			for foot in child.get_children():
				if foot.name.begins_with("legsegment6"):
					rigidbody_children.insert(0, foot)
				#else if foot.name.begins_with("legsegment8"):
					#rigidbody_children.insert(1, foot)
	print(rigidbody_children)
	num_leg_one_side = (len(rigidbody_children) - 1)/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feetDistance = foot1.global_position.distance_to(foot2.global_position)
	if feetDistance > 1000:
		Global.narmDead = true
	if Global.narmDead:
		narmDie()
	if !Global.narmDead:
		queue_redraw()

func narmDie() -> void:
	for child in get_children():
		if child is PinJoint2D:
			child.queue_free();
			
func emit_narm_leg_grabbed(narm_leg: NarmLeg):
	narm_leg_grabbed.emit(narm_leg)
	
func emit_narm_leg_released(narm_leg: NarmLeg):	
	narm_leg_released.emit(narm_leg)
				
	
