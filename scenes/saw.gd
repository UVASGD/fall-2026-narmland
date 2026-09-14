extends Area2D

var rotation_speed : float = 5.0
var lateral_speed : float = 5.0
var distance : float = 100.0
var x_start : float = 1528.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotation_speed * delta)
	
	position.x = x_start + sin(Time.get_ticks_msec() / 1000.0 * lateral_speed) * distance
	
	
	
	
