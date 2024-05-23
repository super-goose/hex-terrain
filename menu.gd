extends Control

var current_node = null

func _ready():
	Events.show_tile_menu.connect(show_tile_menu)
	hide_tile_menu()

func show_tile_menu(tile_node):
	visible = true
	current_node = tile_node
	
func hide_tile_menu():
	visible = false
	current_node = null


func _on_water_button_pressed():
	if current_node:
		current_node.set_type('water')


func _on_grass_button_pressed():
	if current_node:
		current_node.set_type('grass')


func _on_close_button_pressed():
	hide_tile_menu()
