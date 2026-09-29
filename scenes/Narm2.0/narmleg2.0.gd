extends RigidBody2D

enum Side { LEFT, RIGHT }

@export var side : Side
@onready var face : Sprite2D = $"../narmbody/face"

@export var hinge_joint : PinJoint2D 

@export var pull_force : float = 5000.0
@export var slow_radius : float = 10.0

var mouseEntered;
var held := false

func _ready() -> void:
	mouseEntered = false; 

func _physics_process(_delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var button := MOUSE_BUTTON_LEFT if side == Side.LEFT else MOUSE_BUTTON_RIGHT

	if Input.is_mouse_button_pressed(button):
		var to_target := get_global_mouse_position() - state.transform.origin
		var fade := clampf(to_target.length() / slow_radius, 0.0, 1.0)
		state.apply_central_force(to_target.normalized() * pull_force * fade)

func _my_button() -> MouseButton:
	return MOUSE_BUTTON_LEFT if side == Side.LEFT else MOUSE_BUTTON_RIGHT

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == _my_button():
		if event.pressed:
			held = true
			if hinge_joint:
				hinge_joint.node_b = NodePath("")
		else:
			held = false
			# The leg may still be inside a hinge area, where body_entered won't fire again
			for area in get_tree().get_nodes_in_group("hinge"):
				if area.overlaps_body(self):
					attach_to(area)
					break

func attach_to(hinge: Area2D) -> void:
	if hinge_joint == null:
		return
	hinge_joint.global_position = hinge.global_position
	hinge_joint.node_b = hinge.get_parent().get_path()



#func _on_mouse_entered() -> void:
#	mouseEntered = true;
#	Global.mouseSelect = self
#	face.change_face("curious");
	
	

#func _on_mouse_exited() -> void:
#	mouseEntered = false;
#	Global.mouseSelect = null
#	face.change_face("smile");





func _on_area_2d_body_entered(body: Node2D) -> void:
	mouseEntered = false
