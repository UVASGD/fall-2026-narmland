extends RigidBody2D

@onready var face : Sprite2D = $"../narmbody/face"

var mouseEntered;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouseEntered = false; # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouseEntered:
			if Global.mouseSelect == self:
				global_position = get_global_mouse_position();
				linear_velocity = Vector2.ZERO;
	
	


func _on_mouse_entered() -> void:
	mouseEntered = true;
	Global.mouseSelect = self
	face.change_face("curious");
	
	

func _on_mouse_exited() -> void:
	mouseEntered = false;
	Global.mouseSelect = null
	face.change_face("smile");


 # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	mouseEntered = false
