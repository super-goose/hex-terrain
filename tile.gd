extends Node3D

var type = 'grass'

var coords = Vector3i.ZERO
var get_neighbors: Callable

var HexGrass = load("res://assets/land/base/hex_grass.gltf")
var HexWater = load("res://assets/land/base/hex_water.gltf")
var HexCoastA = load("res://assets/land/coast/hex_coast_A.gltf") # water at position 3
var HexCoastB = load("res://assets/land/coast/hex_coast_B.gltf") # water at position 3, 4
var HexCoastC = load("res://assets/land/coast/hex_coast_C.gltf") # water at position 2, 3, 4
var HexCoastD = load("res://assets/land/coast/hex_coast_D.gltf") # water at position 1, 2, 3, 4
var HexCoastE = load("res://assets/land/coast/hex_coast_E.gltf") # no water, but coast at 3.5


func _ready():
	set_mesh()

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		Events.show_tile_menu.emit(self)
		#print(self)
		#print("camera", camera)
		#print("event", event)
		#print("position", position)
		#print("normal", normal)
		#print("shape_idx", shape_idx)

func set_type(t):
	type = t
	set_mesh()

func set_coords(x, z):
	coords = Vector3i(x, 0, z)

func set_get_neighbors(callback: Callable):
	get_neighbors = callback

func set_mesh():
	for child in $MeshContainer.get_children():
		$MeshContainer.remove_child(child)
	match type:
		'grass':
			$MeshContainer.add_child(HexGrass.instantiate())
		'water':
			$MeshContainer.add_child(HexWater.instantiate())
