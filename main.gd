#@tool
extends Node3D

func _ready():
	randomize()

'''
pause, reload, etc
'''
func _process(delta):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("utility_reload"):
			get_tree().reload_current_scene()

		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
