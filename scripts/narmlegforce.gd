extends RigidBody2D

@onready var face : Sprite2D = $"../narmbody/face"

var mouseholding: bool = false
var power = 1000
var legforce
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if mouseholding == true:
		legforce = (get_global_mouse_position() - global_position) * power
		apply_force(legforce, Vector2.ZERO)
		face.change_face("curious")
	else:
		face.change_face("smile")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouseholding = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and mouseholding:
			mouseholding = false
