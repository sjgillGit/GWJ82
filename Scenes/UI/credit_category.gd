class_name CreditCategory extends VBoxContainer

@export var category_name : String

func _ready() -> void:
    %CategoryLabel.text = category_name