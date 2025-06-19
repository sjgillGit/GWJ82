class_name AreaTrap extends Trap

# Set an area3D with collisionshape children to be the trigger area and assign it here
@export var trigger_area : Area3D

func _ready() -> void:
	trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player and !isPreTriggered and !isDisarmed:
		determine_trigger()
