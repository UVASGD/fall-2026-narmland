extends Node2D

@onready var foot1 : RigidBody2D = $legsegment6
@onready var foot2: RigidBody2D = $legsegment8


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(500, 72)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feetDistance = foot1.global_position.distance_to(foot2.global_position)
	if feetDistance > 1000:
		Global.narmDead = true
	if Global.narmDead:
		narmDie()

func narmDie() -> void:
	for child in get_children():
		if child is PinJoint2D:
			child.queue_free();
				
	
