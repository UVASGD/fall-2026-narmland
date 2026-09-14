extends Sprite2D

@onready var eyesOpenTimer : Timer = $eyesOpened
@onready var eyesClosedTimer : Timer = $eyesClosed

@onready var foot1 : RigidBody2D = $"../../legsegment6"
@onready var foot2 : RigidBody2D = $"../../legsegment8"

const SMILE = preload("res://assets/smile.png")
const CURIOUS  = preload("res://assets/curious.png")
const WORRIED = preload("res://assets/worried.png")
const DISTRAUGHT = preload("res://assets/distraught.png")
const SMILE_BLINK = preload("res://assets/smileblink.png")
const CURIOUS_BLINK = preload("res://assets/curiousblink.png")
const WORRIED_BLINK = preload("res://assets/worried blink.png")
const DEAD = preload("res://assets/dead.png")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_face("smile") # Replace with function body.
	eyesOpenTimer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().name== "narmbody":
		var feetDistance = foot1.global_position.distance_to(foot2.global_position)
	
		if Global.narmDead:
			change_face("dead")
		elif feetDistance > 850.0:
			change_face("distraught")
		elif feetDistance > 750.0:
			change_face("worried")

		

	
		
	#print(feetDistance)
	
	
		
func change_face(expression : String) -> void:
	if expression == "smile":
		texture = SMILE
		
	elif expression == "blink":
		if texture == SMILE:
			texture = SMILE_BLINK
		elif texture == CURIOUS:
			texture = CURIOUS_BLINK
		elif texture == WORRIED:
			texture = WORRIED_BLINK
			
	elif expression == "unblink":
		if texture == SMILE_BLINK:
			texture = SMILE
		elif texture == CURIOUS_BLINK:
			texture = CURIOUS
		elif texture == WORRIED_BLINK:
			texture = WORRIED
			
	elif expression == "curious":
		texture = CURIOUS
	elif expression == "worried":
		texture = WORRIED
	elif expression == "distraught":
		texture = DISTRAUGHT
	elif expression == "dead":
		texture = DEAD
	else:
		print("Error: Not a valid texture")

func _on_eyes_closed_timeout() -> void:
	change_face("unblink")
	
	#possible double blink to make Narm seem more "alive"
	if randi_range(0, 10) == 0:
		eyesOpenTimer.wait_time = 0.1
	else:
		eyesOpenTimer.wait_time = randf_range(5.0, 10.0)
		
	eyesOpenTimer.start()
	


	
func _on_eyes_opened_timeout() -> void:
	change_face("blink")
	eyesClosedTimer.start()
	
