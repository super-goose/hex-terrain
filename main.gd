extends Node3D

var Tile = preload("res://tile.tscn")

func _ready():
	for x in range(10):
		for z in range(10):
			var t = Tile.instantiate()
			var x_offset = x * 2 - 10
			if z % 2 == 0:
				x_offset += 1
			t.position.x = x_offset
			t.position.z = z * (3 / sqrt(3))
			$Terrain.add_child(t)
			
