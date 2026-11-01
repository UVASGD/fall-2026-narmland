extends Area2D

#@onready var pinjointfeet1 : PinJoint2D = $"../../Narm/PinJointFeet1"
#@onready var pinjointfeet2 : PinJoint2D = $"../../Narm/PinJointFeet2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# This will print an explicit error message if the path is wrong
	#if get_node_or_null("../../Narm/PinJointFeet1") == null:
		#print_rich("[color=red]CRITICAL ERROR: Hinge cannot find PinJointFeet1 at path: [/color]", get_path_to($"../..") , "/Narm/PinJointFeet1")
	#if get_node_or_null("../../Narm/PinJointFeet2") == null:
		#print_rich("[color=red]CRITICAL ERROR: Hinge cannot find PinJointFeet2 at path: [/color]", get_path_to($"../..") , "/Narm/PinJointFeet2")
	add_to_group("hinge")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	print("hinge entered by ", body.name,
		" has_joint=", "hinge_joint" in body,
		" held=", body.get("held"))
	if not ("hinge_joint" in body) or body.hinge_joint == null:
		return
	if body.held:
		return
	var joint : PinJoint2D = body.hinge_joint
	joint.global_position = global_position
	joint.node_b = get_parent().get_path()

func _on_body_exited(body: Node2D) -> void:
	if not ("hinge_joint" in body) or body.hinge_joint == null:
		return
	var joint : PinJoint2D = body.hinge_joint
	if not joint.node_b.is_empty() and joint.get_node_or_null(joint.node_b) == get_parent():
		joint.node_b = NodePath("")
			
