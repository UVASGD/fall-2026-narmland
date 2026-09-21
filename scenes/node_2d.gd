extends Node2D



func _draw() -> void:
	draw_line(Vector2(50, 50), Vector2(250, 50), Color.GREEN, 5.0)
	
	# Draw a blue solid circle: draw_circle(center_pos, radius, color)
	draw_circle(Vector2(150, 200), 50.0, Color.BLUE)
	
	# Draw a hollow white rectangle: draw_rect(rect, color, filled, width)
	draw_rect(Rect2(50, 300, 200, 100), Color.WHITE, false, 3.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
