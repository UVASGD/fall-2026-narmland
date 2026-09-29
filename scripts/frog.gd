#Frog Notes:
#Movement:
#	-Should stick to ground on landing (to prvent falling or rolling). And frogs have sticky feet
#	-Mini hops to move around
#	-Big hops every few little hops

extends CharacterBody2D

@onready var frog_sprite = $FrogSprite
@onready var timer = $Timer

var hop_time = 0
var hop_count = 0
var hops_till_big_hop = randf_range(2,4)
var on_ground = true

var direction = Vector2.ZERO
var small_hop_scale = 1.0
var big_hop_scale = 5.0

func _process(delta: float) -> void:
	start_hop_timer()
	stick_to_ground()
	decide_hop()

func decide_hop() -> void:
	if timer.is_stopped() and is_landed():
		if hops_till_big_hop >= hop_count:
			big_hop()
			hop_count = 0
		else:
			little_hop()
			hop_count += 1

func is_landed() -> bool:
	return false

func start_hop_timer() -> void:
	if on_ground and timer.is_stopped():
		timer.start(randf_range(2,5))

func big_hop() -> void:
	velocity = direction * small_hop_scale
	
func little_hop() -> void:
	velocity = direction * big_hop_scale
	
func stick_to_ground() -> void:
	if is_landed():
		velocity = Vector2.ZERO
