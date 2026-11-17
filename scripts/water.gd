extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var submerged_bodies: Array[Node2D] = []


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("body ENTERed water", body.name)
	submerged_bodies.append(body)


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("body EXITed water", body.name)
	submerged_bodies.erase(body)


func _physics_process(delta: float) -> void:
	for body in submerged_bodies:
		if body is RigidBody2D:
			body.apply_central_force(Vector2(0, -1200 * body.mass))
