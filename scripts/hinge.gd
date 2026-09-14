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
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	
	var active_narm = body.get_node_or_null("../")
	if not active_narm:
		return
	
	if body.name.begins_with("legsegment8"):
		var joint = active_narm.get_node_or_null("PinJointFeet1")
		if is_instance_valid(joint):
			joint.global_position = global_position
			joint.node_b = get_parent().get_path()	
	elif body.name.begins_with("legsegment6"):
		var joint = active_narm.get_node_or_null("PinJointFeet2")
		if is_instance_valid(joint):
			joint.global_position = global_position
			joint.node_b = get_parent().get_path()

		
	


func _on_body_exited(body: Node2D) -> void:
	var active_narm = body.get_node_or_null("../")
	
	if body.name.begins_with("legsegment8"):
		var joint = active_narm.get_node_or_null("PinJointFeet1")
		if is_instance_valid(joint):
			joint.node_b = NodePath("")
	elif body.name.begins_with("legsegment6"):
		var joint = active_narm.get_node_or_null("PinJointFeet2")
		if is_instance_valid(joint):
			joint.node_b = NodePath("")
			
