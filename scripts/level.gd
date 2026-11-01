extends Node2D

<<<<<<< HEAD
@onready var narmScene = preload("res://scenes/narm.tscn")
@onready var narm2Scene = preload("res://scenes/Narm2.0/narm_2_0.tscn")
=======
@onready var narm_scene = preload("res://scenes/narm.tscn")
>>>>>>> leg-changes
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
<<<<<<< HEAD
	#var narmInstance = narmScene.instantiate()
	var narmInstance = narm2Scene.instantiate()
	add_child(narmInstance)
=======
	var narm_instance = narm_scene.instantiate()
	add_child(narm_instance)
>>>>>>> leg-changes


func _on_saw_body_entered(body: Node2D) -> void:
	Global.narmDead = true
	print("helpf")
