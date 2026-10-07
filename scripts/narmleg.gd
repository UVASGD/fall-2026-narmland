class_name NarmLeg
extends RigidBody2D

@onready var face : Sprite2D = $"../narmbody/face"
@onready var narm: Narm = $"../"

var mouseEntered;
var grabbed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouseEntered = false; # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
		

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) 
	and mouseEntered and Global.mouseSelect == self):
		global_position = get_global_mouse_position();
		linear_velocity = Vector2.ZERO;
		update_grabbed_state(true)
	else:
		update_grabbed_state(false)
				

func update_grabbed_state(b: bool):
	if b and not grabbed:
		narm.emit_narm_leg_grabbed(self)
	elif not b and grabbed:
		narm.emit_narm_leg_released(self)
	grabbed = b	


func _on_mouse_entered() -> void:
	mouseEntered = true;
	Global.mouseSelect = self
	face.change_face("curious");
	
	

func _on_mouse_exited() -> void:
	mouseEntered = false;
	Global.mouseSelect = null
	face.change_face("smile");


func _on_area_2d_body_entered(body: Node2D) -> void:
	mouseEntered = false
