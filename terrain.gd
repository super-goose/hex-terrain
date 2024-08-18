@tool
extends Node3D

@export var width = 10
@export var length = 10

var Tile = preload("res://tile.tscn")
var tiles = {}

func _ready():
	randomize()
	# define the tiles
	for x in range(width):
		for z in range(length):
			# set base type
			var type = 'grass'
			
			# decide if the tile is different
			# if we are near the edge, make it be water
			# determine min distance from the edge
			var dx = min(x, width - 1 - x)
			var dz = min(z, length - 1 - z)
			var d_edge = min(dx, dz)
			
			if d_edge < 2:
				type = 'water'
			elif d_edge < 5:
				var r = randi() % 3
				
				if r < d_edge - 2:
					print('this one got flipped back!')
					type = 'grass'
				else:
					print('this one isn\'t going to be flipped')
					type = 'water'
			#elif d_edge > 8:
				
			
			# add tile to `tiles` dict
			tiles[to_coords_key(x, z)] = { 'type': type, 'rotation': 0, 'coords': { 'x': x, 'z': z } }
	
	# add the tiles
	for coord in tiles:
		add_tile_to_scene(coord, tiles[coord]['type'], tiles[coord]['rotation'])

'''
add each tile to the scene; determine the type of tile to use,
based on the neighboring tiles; determine rotation
'''
func add_tile_to_scene(coords, type, rot):
	var modified_type = type
	var p = from_coords_key(coords)
	var x = p[0]
	var z = p[1]
	var z_offset = z * (3 / sqrt(3)) - ((3 * length / 2) / sqrt(3))
	var x_offset = x * 2 - width
	if z % 2 == 0:
		x_offset += 1

	#if type == 'grass':
		#var neighbors = get_neighbors(x, z)
		#var water_neighbors = neighbors.filter(filter__water_tiles)
		#if water_neighbors.size() > 0:
			#print('----------')
			#print(p)
			#
			#print(water_neighbors)
			#modified_type = 'coast_c'
		
	var t = Tile.instantiate()
	t.position.x = x_offset
	t.position.z = z_offset

	t.set_type(modified_type)
	add_child(t)

func filter__water_tiles(ht):
	if not ht:
		return false
	if ht['type'] == 'water':
		return true

func get_neighbors(x, z):
	return[
		to_coords_key(x-1, z-1),
		to_coords_key(x, z-1),
		to_coords_key(x+1, z),
		to_coords_key(x, z+1),
		to_coords_key(x-1, z+1),
		to_coords_key(x-1, z),
	].map(
		func _neighbor_map(key):
			return tiles[key] if tiles.has(key) else null
	)

func to_coords_key(x, z):
	return "%s,%s" % [x, z]

func from_coords_key(key: String):
	return Array(key.split(',')).map(func (n): return int(n))
