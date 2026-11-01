extends Node2D
class_name Creature

@export_category("Body Parts")
@export var bodies: Array[RigidBody2D]
@export var joint_data: Array[JointData]

@export_category("Creature Interactions")
@export var creature_likes : Array[Creature]
@export var creature_fears : Array[Creature]

@export_category("Debug")
@export var enabled : bool = false
@export var debug_force_scale: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	settle_bodyparts()
	if enabled:
		queue_redraw()

func check_bodypart_grounded(bp: RigidBody2D) -> bool:
	var collision := bp.get_node_or_null("CollisionShape2D") as CollisionShape2D

	if collision == null or not collision.shape is CircleShape2D:
		return false

	var original_circle := collision.shape as CircleShape2D

	var scale_factor : float = max(
		collision.global_transform.x.length(),
		collision.global_transform.y.length()
	)

	var radius := original_circle.radius * scale_factor

	var query_circle := CircleShape2D.new()
	query_circle.radius = radius + 0.5

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = query_circle
	query.transform = Transform2D(0.0, collision.global_position)
	query.collision_mask = 1
	query.exclude = [bp.get_rid()]
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var results := bp.get_world_2d().direct_space_state.intersect_shape(query, 1)

	return not results.is_empty()
func aim_bodypart_to_IKTarget(bp: RigidBody2D, target: Vector2, max_distance: float = 1):
	bp.global_position = (target - bp.global_position).normalized() * max_distance
	pass


func settle_bodyparts() -> void:
	for j in joint_data:
		var b1: RigidBody2D = bodies[j.body_index_1]
		var b2: RigidBody2D = bodies[j.body_index_2]

		var offset := b2.global_position - b1.global_position
		var distance := offset.length()

		if distance < 0.001:
			continue

		var direction := offset / distance
		var relative_velocity := b2.linear_velocity - b1.linear_velocity

		# Distance spring
		var rest_length := j.rest.length()
		var stretch := distance - rest_length
		var radial_speed := relative_velocity.dot(direction)

		var radial_force := direction * (
			-stretch * j.stiffness
			-radial_speed * j.damping
		)

		b2.apply_central_force(radial_force)
		b1.apply_central_force(-radial_force)

		# Angular spring
		var desired_angle := j.rest.angle() + b1.global_rotation
		var current_angle := offset.angle()
		var angle_error := angle_difference(current_angle, desired_angle)

		var tangent := Vector2(-direction.y, direction.x)
		var tangential_speed := relative_velocity.dot(tangent)

		var angular_force := tangent * (
			angle_error * j.angular_stiffness
			-tangential_speed * j.angular_damping
		)

		b2.apply_central_force(angular_force)
		b1.apply_central_force(-angular_force)


#debugger draw for joint data


func _draw() -> void:
	if !enabled:
		return
	for j in joint_data:
		var b1: RigidBody2D = bodies[j.body_index_1]
		var b2: RigidBody2D = bodies[j.body_index_2]

		var offset := b2.global_position - b1.global_position
		var distance := offset.length()

		if distance < 0.001:
			continue

		var direction := offset / distance
		var relative_velocity := b2.linear_velocity - b1.linear_velocity

		# Radial (distance) force
		var rest_length := j.rest.length()
		var stretch := distance - rest_length
		var radial_speed := relative_velocity.dot(direction)

		var radial_force := direction * (
			-stretch * j.stiffness
			-radial_speed * j.damping
		)

		# Angular (tangential) force
		var desired_angle := j.rest.angle() + b1.global_rotation
		var current_angle := offset.angle()
		var angle_error := angle_difference(current_angle, desired_angle)

		var tangent := Vector2(-direction.y, direction.x)
		var tangential_speed := relative_velocity.dot(tangent)

		var angular_force := tangent * (
			angle_error * j.angular_stiffness
			-tangential_speed * j.angular_damping
		)

		# Convert b2 position to local drawing coordinates
		var start := to_local(b2.global_position)

		# Convert force vectors into local drawing coordinates
		var radial_end := to_local(
			b2.global_position + radial_force * debug_force_scale
		)
		var angular_end := to_local(
			b2.global_position + angular_force * debug_force_scale
		)

		# Blue: radial force
		draw_line(start, radial_end, Color.BLUE, 2.0)
		draw_circle(radial_end, 3.0, Color.BLUE)

		# Green: angular force
		draw_line(start, angular_end, Color.GREEN, 2.0)
		draw_circle(angular_end, 3.0, Color.GREEN)
