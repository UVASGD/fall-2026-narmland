extends Control

@onready var hover_sound: AudioStreamPlayer = $HoverSound

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://user_interface/Menus/menu.tscn")
	
func _on_back_button_mouse_entered() -> void:
	hover_sound.play()
