extends RigidBody2D

enum Side { LEFT, RIGHT }


@export var side : Side
@onready var face : Sprite2D = $"../narmbody/face"

@export var pull_strength : float = 300.0   # force per pixel of distance
@export var max_force : float = 6000.0  # caps the pull when far away
@export var damping : float = 10.0

var mouseEntered;

func _ready() -> void:
	mouseEntered = false; 

func _physics_process(_delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var button := MOUSE_BUTTON_LEFT if side == Side.LEFT else MOUSE_BUTTON_RIGHT

	if Input.is_mouse_button_pressed(button):
		var to_target := get_global_mouse_position() - state.transform.origin
		var force := (to_target * pull_strength - state.linear_velocity * damping).limit_length(max_force)
		state.apply_central_force(force)



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
