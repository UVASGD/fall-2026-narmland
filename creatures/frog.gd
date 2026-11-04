extends "res://creatures/creature.gd"

@onready var timer = $Timer
@onready var torso: RigidBody2D = $Bodies/Torso
@onready var feet: RigidBody2D = $Bodies/Feet
@onready var grab_box: Area2D = $Bodies/Torso/GrabBox


@export var small_hop_strength := 450
@export var big_hop_strength := 1300
@export var crouch_amount := 0.5
@export var small_crouch_time := 0.1
@export var big_crouch_time := 0.3

var hop_count := 0
var hops_till_big_hop := randi_range(2,4)
var hop_queued := false
var hopping := false

var grab_joint: PinJoint2D
var leg_joint: JointData
var base_rest: Vector2
var direction := 1
var attatched_arm: RigidBody2D = null

func _ready() -> void:
	super._ready()
	for i in joint_data.size():
		joint_data[i] = joint_data[i].duplicate()
	leg_joint = joint_data[0]
	base_rest = leg_joint.rest
	
	for b in bodies:
		b.contact_monitor = true
		b.max_contacts_reported = 4
	
	#To allow for crouching, although crouching not working for some reason
	torso.add_collision_exception_with(feet)
	
	timer.one_shot = true
	timer.timeout.connect(func(): hop_queued = true)
	timer.start(randf_range(2, 5))
	
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if attatched_arm and attatched_arm.grabbed:
		release()
	var is_big_hop = (hop_count >= hops_till_big_hop)
	if hop_queued and not hopping and is_landed():
		hop_queued = false
		if is_big_hop:
			hop(big_hop_strength, big_crouch_time, is_big_hop)
			hop_count = 0
			hops_till_big_hop = randi_range(2, 4)
		else:
			hop(small_hop_strength, small_crouch_time, not is_big_hop)
			hop_count += 1
		timer.start(randf_range(2,4))

func is_landed() -> bool:
	for other in feet.get_colliding_bodies():
		if other not in bodies:
			return true
	return false

func hop(strength: float, crouch_time: float, big_hop: bool) -> void:
	hopping = true
	
	if randf() < 0.5:
		set_direction(-direction)
		
	leg_joint.rest = base_rest * crouch_amount
	await get_tree().create_timer(crouch_time, false, true).timeout
	
	leg_joint.rest = base_rest
	var impulse := Vector2(direction, -1.5).normalized() * strength
	if big_hop:
		impulse = Vector2(direction*0.25, -1.5).normalized() * strength
	torso.apply_central_impulse(impulse * torso.mass)
	feet.apply_central_impulse(impulse * feet.mass)
	
	hopping = false
	
#For springy physics. Can use base creature physics if thats preferred but
#Made this for now to fit frog
func apply_springs() -> void:
	for j in joint_data:
		var b1: RigidBody2D = bodies[j.body_index_1]
		var b2: RigidBody2D = bodies[j.body_index_2]

		var offset = b2.global_position - b1.global_position
		var rel_vel = b2.linear_velocity - b1.linear_velocity
		
		var force = (j.rest - offset) * j.stiffness - rel_vel * j.damping
		b2.apply_central_force(force)
		b1.apply_central_force(-force)
		
func set_direction(new_direction: int) -> void:
	if new_direction == direction:
		return
	direction = new_direction

	for b in bodies:
		for child in b.get_children():
			if child is Node2D:
				child.position.x = -child.position.x
			if child is Sprite2D:
				child.flip_h = direction < 0
				child.offset.x = -child.offset.x


	base_rest.x = -base_rest.x
	leg_joint.rest.x = -leg_joint.rest.x
	
	
func grab(leg: RigidBody2D):
	var active_narm = leg.get_node_or_null("../")
	if leg.name.begins_with("legsegment6"):
		var joint = active_narm.get_node_or_null("PinJointFeet2")
		if is_instance_valid(joint):
			joint.global_position = global_position
			joint.node_b = get_parent().get_path()	
		attatched_arm = leg
	if leg.name.begins_with("legsegment8"):
		var joint = active_narm.get_node_or_null("PinJointFeet1")
		if is_instance_valid(joint):
			joint.global_position = global_position
			joint.node_b = joint.get_path_to(torso)
		attatched_arm = leg

func release():
	if grab_joint:
		grab_joint.queue_free()
		grab_joint = null

func _on_grab_box_body_entered(body: Node2D) -> void:
	var active_narm = body.get_node_or_null("../")
	if not active_narm:
		return
	if not (body.name.begins_with("legsegment6") or body.name.begins_with("legsegment8")):
		return
	grab(body)
	
func _on_grab_box_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
