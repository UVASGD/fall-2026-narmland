extends Node2D

@onready var narmScene = preload("res://scenes/narm.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	narmRevive() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("revive"):
		for child in get_children():
			if child.name.begins_with("Narm"):
				child.queue_free()
				narmRevive()
	

func narmRevive() -> void:
	print("revive")
	Global.narmDead = false
	var narmInstance = narmScene.instantiate()
	add_child(narmInstance)


func _on_saw_body_entered(body: Node2D) -> void:
	Global.narmDead = true
	print("helpf")
