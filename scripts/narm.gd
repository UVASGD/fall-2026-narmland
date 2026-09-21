extends Node2D

@onready var foot1 : RigidBody2D = $legsegment6
@onready var foot2: RigidBody2D = $legsegment8

var rigidbody_children : Array[RigidBody2D] = []
func _draw() -> void:
	for i in range(len(rigidbody_children)):
		
		var child1 = rigidbody_children[i]
		var child2
		if i >= len(rigidbody_children) - 1:
			child2 = child1
		else:
			child2 = rigidbody_children[i+1]
		draw_line(child1.position, child2.position, Color.YELLOW, 20.0)
		
	draw_line(Vector2(50, 50), Vector2(250, 50), Color.GREEN, 5.0)
	
	# Draw a blue solid circle: draw_circle(center_pos, radius, color)
	draw_circle(Vector2(150, 200), 50.0, Color.BLUE)
	
	# Draw a hollow white rectangle: draw_rect(rect, color, filled, width)
	draw_rect(Rect2(50, 300, 200, 100), Color.WHITE, false, 3.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(500, 72)
	for child in get_children():
		if child is RigidBody2D:
			rigidbody_children.append(child)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var feetDistance = foot1.global_position.distance_to(foot2.global_position)
	if feetDistance > 1000:
		Global.narmDead = true
	if Global.narmDead:
		narmDie()
	if !Global.narmDead:
		queue_redraw()

func narmDie() -> void:
	for child in get_children():
		if child is PinJoint2D:
			child.queue_free();
				
	
