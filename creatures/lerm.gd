extends Creature
class_name Lerm
@export_category("Setup")
@export var head_index : int
@export var target : Node2D

@export_category("Behavior")
@export var burrow_thrust: float = 1000.0
@export var launch_speed_boost: float = 1000.0
@export var recover_time: float = 10
@export var burrow_drag: float = 5
enum LermState
{
	BURROW,
	AIRBORNE,
	RECOVER
}

var currentState : LermState
var head : RigidBody2D
var recovery_timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head = bodies[head_index]
	recovery_timer = recover_time
	var currentState: LermState = LermState.BURROW


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_burrow_buoyancy()
	match currentState:
		LermState.BURROW:
			if (!check_bodypart_grounded(head)):
				switch_state(LermState.AIRBORNE)
			propel_head()
		LermState.AIRBORNE:
			if (check_bodypart_grounded(head)):
				switch_state(LermState.RECOVER)
				recovery_timer = recover_time
			launch_head()
		LermState.RECOVER:
			recovery_timer -= delta
			if(recovery_timer <= 0):
				switch_state(LermState.BURROW)
	super._physics_process(delta)

func switch_state(newState : LermState):
	print("Switched Lerm State to " + str (newState))
	currentState = newState
func apply_burrow_buoyancy() -> void:
	var gravity: float = ProjectSettings.get_setting(
		"physics/2d/default_gravity"
	)
	for bp in bodies:
		if not check_bodypart_grounded(bp):
			continue
		var upward_force := (
			Vector2.UP
			* bp.mass
			* gravity
		)
		var downward_speed :float= max(bp.linear_velocity.y, 0.0)

		var drag_force := (
			Vector2.UP
			* downward_speed
			* bp.mass
			* burrow_drag
		)

		bp.apply_central_force(upward_force + drag_force)

func propel_head() -> void:
	if target == null:
		return

	var direction := target.global_position - head.global_position

	if direction.length_squared() < 0.001:
		return

	# Do not accelerate beyond the configured speed
	# in the target direction.
	var heading := direction.normalized()
	var forward_speed := head.linear_velocity.dot(heading)


	head.apply_central_force(heading * burrow_thrust)
func launch_head() -> void:
	var direction := head.linear_velocity.normalized()

	if direction == Vector2.ZERO:
		return

	head.apply_central_impulse(
		direction * head.mass * launch_speed_boost
	)
