extends Node2D

@onready var cooldown = $CooldownTimer

enum state {OPEN, CLOSED, RELEASING}
var trapped_leg: RigidBody2D = null
var trapped_joint: PinJoint2D = null
var current_state: state = state.OPEN

func _ready() -> void:
	cooldown.timeout.connect(_on_timer_timeout)

func _on_trigger_box_body_entered(body: Node2D) -> void:
	if current_state == state.RELEASING:
		return
	if body.scene_file_path != "res://scenes/legsegment.tscn":
		return
	
	var joint_name = ""
	if body.name.begins_with("legsegment8"):
		joint_name = "PinJointFeet1"
	if body.name.begins_with("legsegment6"):
		joint_name = "PinJointFeet2"
	if joint_name == "":
		return
		
	var active_narm = body.get_node_or_null("../")
	if not active_narm:
		return
	
	if current_state == state.OPEN:
		catch(body, joint_name)
	elif current_state == state.CLOSED and body != trapped_leg:
		release()

func catch(body, joint_name):
	current_state = state.CLOSED
	body.trapped = true
	trapped_leg = body
	var active_narm = body.get_parent()
	var joint = active_narm.get_node_or_null(joint_name)
	if is_instance_valid(joint):
		joint.global_position = global_position
		joint.node_b = get_path()
		trapped_joint = joint
		
func release():
	current_state = state.RELEASING
	if is_instance_valid(trapped_joint):
		trapped_joint.node_b = NodePath("")
	trapped_leg.trapped = false
	trapped_leg = null
	trapped_joint = null
	cooldown.start()

func _on_timer_timeout():
	current_state = state.OPEN
