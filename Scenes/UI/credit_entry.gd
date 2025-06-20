class_name CreditEntry extends VBoxContainer

@export var username : String
@export var full_name : String
@export var links: Array

@onready var username_label : Label = %UsernameLabel
@onready var full_name_label : Label = %FullNameLabel

func _ready() -> void:
	username_label.text = username
	if full_name: 
		full_name_label.visible = true
		full_name_label.text = full_name

	for link in links:
		var link_button = LinkButton.new()
		link_button.text = link
		link_button.uri = link

		# Center the button
		link_button.grow_horizontal = HORIZONTAL_ALIGNMENT_CENTER
		link_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		add_child(link_button)
