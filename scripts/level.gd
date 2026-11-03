extends Node2D

@onready var narmScene = preload("res://scenes/narm.tscn")
@onready var narm2Scene = preload("res://scenes/Narm2.0/narm_2_0.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	narm_revive() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("revive"):
		for child in get_children():
			if child.name.begins_with("Narm"):
				child.queue_free()
				narm_revive()
	

func narm_revive() -> void:
	print("revive")
	Global.narmDead = false
	var narmInstance = narmScene.instantiate()
	#var narmInstance2 = narm2Scene.instantiate()
	add_child(narmInstance)
	#add_child(narmInstance2)


func _on_saw_body_entered(body: Node2D) -> void:
	Global.narmDead = true
	print("helpf")
