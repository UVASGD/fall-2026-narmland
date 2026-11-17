extends Creature
class_name Goober
@export_category("Setup")
@export var BodyIndex: int;
@export var LegsIndex: Array[int];

@export_category("Behavior")
@export var minStrideLength: float;

const LEG_L_REST : Vector2 = Vector2(-10,10);
const LEG_R_REST : Vector2 = Vector2(10,10);

var grounded: bool;

var body: RigidBody2D;
# Called when the node enters the scene tree for the first time.
func _process(_delta) -> void:
	if(Input.get_axis("ui_left","ui_right") < 0):
		print("attempt stide left");
		_stride(false);
	if(Input.get_axis("ui_left","ui_right") > 0):
		print("attempt stide right");
		_stride(true);
	pass # Replace with function body.


func _stride(right : bool):
	
	var legL : RigidBody2D
	var legR : RigidBody2D
	var legLi : int
	var legRi : int
	if(bodies[LegsIndex[0]].global_position.x < bodies[LegsIndex[1]].global_position.x):
		legLi = LegsIndex[0];
		legRi = LegsIndex[1];
	else:
		legLi = LegsIndex[1];
		legRi = LegsIndex[0];
	legL = bodies[legLi];
	legR = bodies[legRi];
	
	#legs too close. do not attempt to stride
	if(sign(legR.global_position.x - legL.global_position.x) * legR.global_position.x - legL.global_position.x < minStrideLength):
		return
	print("stride")
	unanchor_bodypart(legR)
	unanchor_bodypart(legL)
	var jointL = get_joint_from_bpi(legLi, BodyIndex);
	var jointR = get_joint_from_bpi(legRi, BodyIndex);
	if(right):
		anchor_bodypart(legR)
	else:
		anchor_bodypart(legL)
	jointL.rest = Vector2(10, 10);
	jointR.rest = Vector2(-10, 10);
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
