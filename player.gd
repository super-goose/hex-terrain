extends CharacterBody3D

func _ready():
	pass

func _physics_process(delta):
	velocity.y = -10
	move_and_slide()
	
