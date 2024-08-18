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


func _on_coast_a_button_pressed():
	if current_node:
		current_node.set_type('coast_a')

func _on_coast_b_button_pressed():
	if current_node:
		current_node.set_type('coast_b')

func _on_coast_c_button_pressed():
	if current_node:
		current_node.set_type('coast_c')

func _on_coast_d_button_pressed():
	if current_node:
		current_node.set_type('coast_d')

func _on_coast_e_button_pressed():
	if current_node:
		current_node.set_type('coast_e')

func _on_river_a_button_pressed():
	if current_node:
		current_node.set_type('river_a')

func _on_river_a_curvy_button_pressed():
	if current_node:
		current_node.set_type('river_a_curvy')

func _on_river_b_button_pressed():
	if current_node:
		current_node.set_type('river_b')

func _on_river_c_button_pressed():
	if current_node:
		current_node.set_type('river_c')

func _on_river_d_button_pressed():
	if current_node:
		current_node.set_type('river_d')

func _on_river_e_button_pressed():
	if current_node:
		current_node.set_type('river_e')

func _on_river_f_button_pressed():
	if current_node:
		current_node.set_type('river_f')

func _on_river_g_button_pressed():
	if current_node:
		current_node.set_type('river_g')

func _on_river_h_button_pressed():
	if current_node:
		current_node.set_type('river_h')

func _on_river_i_button_pressed():
	if current_node:
		current_node.set_type('river_i')

func _on_river_j_button_pressed():
	if current_node:
		current_node.set_type('river_j')

func _on_river_k_button_pressed():
	if current_node:
		current_node.set_type('river_k')

func _on_river_l_button_pressed():
	if current_node:
		current_node.set_type('river_l')

func _on_river_crossing_a_button_pressed():
	if current_node:
		current_node.set_type('river_crossing_a')

func _on_river_crossing_b_button_pressed():
	if current_node:
		current_node.set_type('river_crossing_b')


func _on_ccw_button_pressed():
	if current_node:
		current_node.rotate_tile('ccw')


func _on_cw_button_pressed():
	if current_node:
		current_node.rotate_tile('cw')
