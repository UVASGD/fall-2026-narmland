extends Control

@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var play_sound: AudioStreamPlayer = $PlaySound

func _ready() -> void:
	for button in $PanelContainer/VBoxContainer/VBoxContainer.get_children():
		if button is Button:
			button.mouse_entered.connect(hover_sound.play)
			button.focus_entered.connect(hover_sound.play)

func _on_play_button_pressed() -> void:
	play_sound.play()
	await play_sound.finished
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")

func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://user_interface/Menus/options.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
