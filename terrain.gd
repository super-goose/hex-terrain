@tool
extends Node3D

@export var width = 10
@export var length = 10
@export var q_radius = 5
@export var r_radius = 5
@export var s_radius = 5

var Tile = preload("res://tile.tscn")
var tiles = {}

func add_tile_to_map(q, r, s):
	var type = 'grass'
	
	# decide if the tile is different
	# if we are near the edge, make it be water
	# determine min distance from the edge
	var elevation = 0
	#var dx = min(x, width - 1 - x)
	#var dz = min(z, length - 1 - z)
	#var d_edge = min(dx, dz)
	var dq = q_radius - abs(q)
	var dr = r_radius - abs(r)
	var ds = s_radius - abs(s)
	
	
	var d_edge = min(dq, dr, ds)
	
	if d_edge < 2:
		type = 'water'
	elif d_edge < 5:
		var coef = randi() % 3
		
		if coef < d_edge - 1:
			type = 'grass'
		else:
			type = 'water'
	elif d_edge > 6:
		elevation += d_edge - 6

	var coord = { 'q': q, 'r': r, 's': s }
	tiles[to_cubic_coords_key({ 'q': q, 'r': r, 's': s })] = {
		'type': type,
		'rotation': 0,
		'oddr': cube_to_oddr(coord),
		'cube': coord,
		'elevation': elevation,
	}

func _ready():
	randomize()
	# define the tiles
	for q in range(-q_radius, q_radius + 1):
		for r in range(-r_radius, r_radius + 1):
			for s in range(-s_radius, s_radius + 1):
				if q + r + s == 0:
					add_tile_to_map(q, r, s)

	
	# add the tiles
	for coord in tiles:
		add_tile_to_scene(
			coord,
			tiles[coord],
		)

'''
add each tile to the scene; determine the type of tile to use,
based on the neighboring tiles; determine rotation
'''
func add_tile_to_scene(coords, tile):
	var type = tile['type']
	var rotation = tile['rotation']
	var elevation = tile['elevation']
	var modified_type = type
	var p_cube = from_cubic_coords_key(coords)
	var p = cube_to_oddr(p_cube)
	var x = p['x']
	var z = p['z']
	var y_offset = elevation / 2.0
	var z_offset = z * (3 / sqrt(3)) - ((3 * length / 2) / sqrt(3))
	var x_offset = x * 2 - width
	if z & 1 == 1:
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
	t.position.y = y_offset
	t.position.z = z_offset
	t.set_data(tile)

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

func to_cubic_coords_key(c):
	return "%s,%s,%s" % [c['q'], c['r'], c['s']]

func from_cubic_coords_key(key):
	var arr = Array(key.split(',')).map(func (n): return int(n))
	return {
		'q': arr[0],
		'r': arr[1],
		's': arr[2],
	}

func cube_to_oddr(hex):
	var col = hex['q'] + (hex['r'] - (hex['r']&1)) / 2
	var row = hex['r']
	return { 'x': col, 'z': row }

func oddr_to_cube(hex):
	var q = hex['x'] - (hex['z'] - (hex['z']&1)) / 2
	var r = hex['z']
	return { 'q': q, 'r': r, 's': -q-r }
