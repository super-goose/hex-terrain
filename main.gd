extends Node3D

var Tile = preload("res://tile.tscn")
var tiles = {}

func _ready():
	for x in range(10):
		for z in range(10):
			var z_offset = z * (3 / sqrt(3)) - (15 / sqrt(3))
			var x_offset = x * 2 - 10
			if z % 2 == 0:
				x_offset += 1

			var t = Tile.instantiate()
			t.position.x = x_offset
			t.position.z = z_offset
			$Terrain.add_child(t)
			#await get_tree().create_timer(.01).timeout
	

func get_neighbors(x, z):
	
	return[
		as_coords_key(x-1, z-1),
		as_coords_key(x, z-1),
		as_coords_key(x+1, z),
		as_coords_key(x, z+1),
		as_coords_key(x-1, z+1),
		as_coords_key(x-1, z),
	].map(
		func _neighbor_map(key):
			return tiles[key] if tiles.has(key) else null
	)

func as_coords_key(x, z):
	return "%s,%s" % [x, z]

'''
pause, reload, etc
'''
func _process(delta):
	if Input.is_action_just_pressed("utility_reload"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
