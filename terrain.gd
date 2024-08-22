@tool
extends Node3D

@export var q_radius = 5
@export var r_radius = 5
@export var s_radius = 5
@export var max_distance_for_elevation = 5
@export var noise = FastNoiseLite.new()


var Tile = preload("res://tile.tscn")
var tiles = {}

func add_tile_to_map(q, r, s, noise_value):
	var type = 'grass'
	var elevation = int(10 * noise_value + 3)
	
	# decide if the tile is different
	# if we are near the edge, make it be water
	# determine min distance from the edge
	var dq = q_radius - abs(q)
	var dr = r_radius - abs(r)
	var ds = s_radius - abs(s)
	
	var d_edge = min(dq, dr, ds)
	
	if d_edge < 1 or elevation < 0:
		type = 'water'
		elevation = 0
	#elif d_edge < 5:
		#var coef = randi() % 3
		#
		#if coef < d_edge - 2:
			#type = 'grass'
		#else:
			#type = 'water'

	var coord = { 'q': q, 'r': r, 's': s }
	tiles[to_cubic_coords_key({ 'q': q, 'r': r, 's': s })] = {
		'type': type,
		'rotation': 0,
		'oddr': cube_to_oddr(coord),
		'cube': coord,
		'elevation': elevation,
	}

func get_distance_to_nearest_water(coord):
	# quick and dirty
	for d in range(0, max_distance_for_elevation):
		var all_hexes = get_all_hexes_within_distance(d, coord)
		if all_hexes.filter(
			func filter__water_tiles_from_coord_keys(coord):
				return coord in tiles and filter__water_tiles(tiles[coord])
		).size():
			return d
	return max_distance_for_elevation

func assign_elevations():
	for q in range(-q_radius, q_radius + 1):
		for r in range(-r_radius, r_radius + 1):
			var s = -q - r
			var coord = { 'q': q, 'r': r, 's': s }
			var distance_to_water = get_distance_to_nearest_water(coord)
			if distance_to_water - 1 > 0:
				if to_cubic_coords_key(coord) in tiles:
					tiles[to_cubic_coords_key(coord)]['elevation'] = distance_to_water - 1

func generate_map():
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 5
	noise.fractal_gain = 0.5
	noise.frequency = 0.01

	for q in range(-q_radius, q_radius + 1):
		for r in range(-r_radius, r_radius + 1):
			for s in range(-s_radius, s_radius + 1):
				if q + r + s == 0:
					add_tile_to_map(q, r, s, noise.get_noise_3d(q, r, s))


func _ready():
	randomize()
	# define the tiles
	generate_map()
	
	assign_elevations()
	
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
	var y_offset = max(elevation / 2.0, 0)
	var z_offset = z * (3 / sqrt(3))
	var x_offset = x * 2
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
	return ht['type'] == 'water'

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

'''
UTIL FUNCTIONS
'''

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

func get_all_hexes_within_distance(d, hex):
	var results = []
	for q in range(hex['q'] - d, hex['q'] + d + 1):
		for r in range(hex['r'] - d, hex['r'] + d + 1):
			var s = -q - r
			var coord = to_cubic_coords_key({ 'q': q, 'r': r, 's': s })
			if coord in tiles:
				results.append(coord)
	return results
