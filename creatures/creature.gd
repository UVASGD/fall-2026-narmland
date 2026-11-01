extends Node

@export var bodies: Array[RigidBody2D]
@export var joint_data: Array[JointData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if bodies.size() != joint_data.size():
	#	push_warning("Creature " + str(self) + "has unequal number of bodies and joint_data in inspector")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for j in joint_data:
		var b1 : RigidBody2D = bodies[j.body_index_1]
		var b2 : RigidBody2D = bodies[j.body_index_2]
		var rest: Vector2 = j.rest
		var stiffness : float = j.stiffness
		var dampening : float = j.dampening
		var a_stiffness : float = j.angular_stiffness
		var a_dampening : float = j.angular_dampening
		
		#length constraint
		var displacement = b2.global_position - b1.global_position
		var stretch : float =  rest.length() - displacement.length() # -X is stretched, +X is compressed
		
		b1.apply_force(-displacement.normalized() * stretch * stiffness)
		b2.apply_force(displacement.normalized() * stretch * stiffness)
		b1.apply_force(-b1.linear_velocity * dampening)
		b2.apply_force(-b2.linear_velocity * dampening)
		
		
		#angle
		var angular_stretch : float = angle_difference((displacement).angle(), rest.angle())
		b1.apply_torque(angular_stretch * a_stiffness)
		b2.apply_torque(-angular_stretch * a_stiffness)
		
		#var angular_displacement = 
	pass
