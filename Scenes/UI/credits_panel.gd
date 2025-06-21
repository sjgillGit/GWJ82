class_name CreditsPanel extends PanelContainer

@onready var category_container := %CreditVBox

var credits = {
	"Artists": [
		{
			"username": "Vixx",
		},
		{
			"username": "mike3D",
		},
		{
			"username": "XZO",
		},
	],
	"Coders": [
		{
			"username": "Dutt1ez / Sean Wilcox",
			"links": ["https://github.com/SeanDutt"]
		},
		{
			"username": "Zeteraxis",
		},
		{
			"username": "Jechtoff",
			"links": ["https://itch.io/jechtoff", "https://bsky.app/profile/jechtmakesgames.bsky.social"]
		},
		{
			"username": "asvo777",
		},
		{
			"username": "Cyrus",
		}
	],
	"Sound": [
		{
			"username": "fiberbundles",
		},
		{
			"username": "andoti",
			"links": ["https://andoti.bandcamp.com/"]
		}
	]
}

func _ready() -> void:
	build_credits()

func build_credits() -> void:
	var entry_scene = preload("res://Scenes/UI/credit_entry.tscn")
	var category_scene = preload("res://Scenes/UI/credit_category.tscn")

	for category in credits:
		var cat_box = category_scene.instantiate()
		cat_box.category_name = category
		category_container.add_child(cat_box)

		for entry in credits[category]:
			var new_entry = entry_scene.instantiate()
			new_entry.username = entry.get("username", "")
			new_entry.full_name = entry.get("full_name", "")
			new_entry.links = entry.get("links", [])
			cat_box.add_child(new_entry)
		
		var separator = HSeparator.new()
		separator.size_flags_horizontal = SIZE_EXPAND_FILL
		cat_box.add_child(separator)
