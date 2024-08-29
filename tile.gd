@tool
extends Node3D

var type = 'grass'
var decoration = 'none'

var data
var coords = Vector3i.ZERO
var get_neighbors: Callable

var HexGrass = load("res://assets/land/base/hex_grass.gltf")
var HexWater = load("res://assets/land/base/hex_water.gltf")
var HexCoastA = load("res://assets/land/coast/hex_coast_A.gltf") # water at position 3
var HexCoastB = load("res://assets/land/coast/hex_coast_B.gltf") # water at position 3, 4
var HexCoastC = load("res://assets/land/coast/hex_coast_C.gltf") # water at position 2, 3, 4
var HexCoastD = load("res://assets/land/coast/hex_coast_D.gltf") # water at position 1, 2, 3, 4
var HexCoastE = load("res://assets/land/coast/hex_coast_E.gltf") # no water, but coast at 3.5

var HexRiverA = load("res://assets/land/rivers/hex_river_A.gltf")
var HexRiverACurvy = load("res://assets/land/rivers/hex_river_A_curvy.gltf")
var HexRiverB = load("res://assets/land/rivers/hex_river_B.gltf")
var HexRiverC = load("res://assets/land/rivers/hex_river_C.gltf")
var HexRiverD = load("res://assets/land/rivers/hex_river_D.gltf")
var HexRiverE = load("res://assets/land/rivers/hex_river_E.gltf")
var HexRiverF = load("res://assets/land/rivers/hex_river_F.gltf")
var HexRiverG = load("res://assets/land/rivers/hex_river_G.gltf")
var HexRiverH = load("res://assets/land/rivers/hex_river_H.gltf")
var HexRiverI = load("res://assets/land/rivers/hex_river_I.gltf")
var HexRiverJ = load("res://assets/land/rivers/hex_river_J.gltf")
var HexRiverK = load("res://assets/land/rivers/hex_river_K.gltf")
var HexRiverL = load("res://assets/land/rivers/hex_river_L.gltf")
var HexRiverCrossingA = load("res://assets/land/rivers/hex_river_crossing_A.gltf")
var HexRiverCrossingB = load("res://assets/land/rivers/hex_river_crossing_B.gltf")

var Tree0 = load("res://assets/decoration/nature/trees_A_medium.gltf")
var Tree1 = load("res://assets/decoration/nature/trees_A_small.gltf")
var Rock0 = load("res://assets/decoration/nature/rock_single_C.gltf")
var Rock1 = load("res://assets/decoration/nature/rock_single_E.gltf")
var Hill0 = load("res://assets/decoration/nature/hills_B.gltf")
var Hill1 = load("res://assets/decoration/nature/hills_C.gltf")
var TreeHill0 = load("res://assets/decoration/nature/hills_B_trees.gltf")
var TreeHill1 = load("res://assets/decoration/nature/hills_C_trees.gltf")

func flip_a_coin():
	return randi_range(0, 1) == 0

func _ready():
	set_mesh()

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if Engine.is_editor_hint():
			print(data)
		else:
			Events.show_tile_menu.emit(self)
		#print(self)
		#print("camera", camera)
		#print("event", event)
		#print("position", position)
		#print("normal", normal)
		#print("shape_idx", shape_idx)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(coords)

func set_type(t):
	type = t
	set_mesh()

func set_decoration(d):
	decoration = d
	set_decoration_mesh()

func set_data(d):
	data = d
	var coords_str = "(%s, %s)" % [data['oddr']['x'], data['oddr']['z']]
	var cube_str = "(%s, %s, %s)" % [data['cube']['q'], data['cube']['r'], data['cube']['s']]
	$Label3D.text = coords_str + '\n' + cube_str

func set_coords(x, z):
	coords = Vector3i(x, 0, z)

func set_get_neighbors(callback: Callable):
	get_neighbors = callback

func rotate_tile(d):
	if d == 'ccw':
		rotate_y(PI / 3)
	elif d == 'cw':
		rotate_y(-PI / 3)

func set_elevation(e: int):
	$MeshContainer.scale.y = e + 1
	position.y = e

func set_decoration_mesh():
	for child in $DecorationContainer.get_children():
		$DecorationContainer.remove_child(child)
	match decoration:
		'tree':
			$DecorationContainer.add_child(Tree0.instantiate() if flip_a_coin() else Tree1.instantiate())
		'rock':
			$DecorationContainer.add_child(Rock0.instantiate() if flip_a_coin() else Rock1.instantiate())
		'hill':
			$DecorationContainer.add_child(Hill0.instantiate() if flip_a_coin() else Hill1.instantiate())
		'tree-hill':
			$DecorationContainer.add_child(TreeHill0.instantiate() if flip_a_coin() else TreeHill1.instantiate())
		'none':
			pass
		_:
			print('not implemented:', decoration)

func set_mesh():
	for child in $MeshContainer.get_children():
		$MeshContainer.remove_child(child)
	match type:
		'grass':
			$MeshContainer.add_child(HexGrass.instantiate())
		'water':
			$MeshContainer.add_child(HexWater.instantiate())
		'coast_a':
			$MeshContainer.add_child(HexCoastA.instantiate())
		'coast_b':
			$MeshContainer.add_child(HexCoastB.instantiate())
		'coast_c':
			$MeshContainer.add_child(HexCoastC.instantiate())
		'coast_d':
			$MeshContainer.add_child(HexCoastD.instantiate())
		'coast_e':
			$MeshContainer.add_child(HexCoastE.instantiate())
		'river_a':
			$MeshContainer.add_child(HexRiverA.instantiate())
		'river_a_curvy':
			$MeshContainer.add_child(HexRiverACurvy.instantiate())
		'river_b':
			$MeshContainer.add_child(HexRiverB.instantiate())
		'river_c':
			$MeshContainer.add_child(HexRiverC.instantiate())
		'river_d':
			$MeshContainer.add_child(HexRiverD.instantiate())
		'river_e':
			$MeshContainer.add_child(HexRiverE.instantiate())
		'river_f':
			$MeshContainer.add_child(HexRiverF.instantiate())
		'river_g':
			$MeshContainer.add_child(HexRiverG.instantiate())
		'river_h':
			$MeshContainer.add_child(HexRiverH.instantiate())
		'river_i':
			$MeshContainer.add_child(HexRiverI.instantiate())
		'river_j':
			$MeshContainer.add_child(HexRiverJ.instantiate())
		'river_k':
			$MeshContainer.add_child(HexRiverK.instantiate())
		'river_l':
			$MeshContainer.add_child(HexRiverL.instantiate())
		_:
			print('not implemented:', type)
