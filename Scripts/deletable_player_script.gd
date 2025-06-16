extends RigidBody3D

@onready var trapBody = $"../TrapMeshInstace3D"
@onready var trap = $"../Trap_example"
var speed = 650

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trapBody.visible = false # Replace with function body.

func _input(event):
	if(event.is_action_pressed("space")):
		var speed = 0
	else:
		var speed = 650

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_central_force(Vector3.FORWARD * speed * delta)


func _on_trap_example_body_entered(body: Node3D) -> void:
	if(trap.isDisarmed == false):
		trapBody.visible = true # Replace with function body.
		trap.trigger()
	
