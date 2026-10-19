extends RigidBody2D

enum Side { LEFT, RIGHT }

@export var side : Side
@onready var face : Sprite2D = $"../narmbody/face"

@export var hinge_joint : PinJoint2D 

@export var pull_force : float = 10000
@export var slow_radius : float = 10.0

@export var kick_impulse : float = 2000     # one-time burst on press (mass * speed)
@export var spring_strength : float = 40.0   # higher = snappier, springier
@export var damping : float = 2.0            # lower = more bounce, higher = smoother
@export var hold_force : float = 1500.0      # hard cap on the sustained pull
@export var kick_cooldown : float = 1.0   # seconds before the kick can fire again

var last_kick_time := -100000.0   # ms; starts far in the past so the first kick works
var kick_pending := false


var mouseEntered;
var held := false

func _ready() -> void:
	mouseEntered = false; 

func _physics_process(_delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not Input.is_mouse_button_pressed(_my_button()):
		return

	var to_target := get_global_mouse_position() - state.transform.origin

	if kick_pending:
		kick_pending = false
		state.apply_central_impulse(to_target.normalized() * kick_impulse)

	# Spring toward the cursor, with damping so it bounces but settles
	var force := to_target * spring_strength - state.linear_velocity * damping * mass
	state.apply_central_force(force.limit_length(hold_force))


func _my_button() -> MouseButton:
	return MOUSE_BUTTON_LEFT if side == Side.LEFT else MOUSE_BUTTON_RIGHT

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == _my_button():
		if event.pressed:
			held = true
			var now := Time.get_ticks_msec()
			if now - last_kick_time >= kick_cooldown * 1000.0:
				kick_pending = true
				last_kick_time = now
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
