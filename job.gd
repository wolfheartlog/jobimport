extends Node

var csv_path : String = "res://resource/class.csv"

var data : Array
@onready var data_display_container : VBoxContainer = $CanvasLayer/VBoxContainer
@onready var option_button : OptionButton = $CanvasLayer/OptionButton
@onready var job_label : Label = $CanvasLayer/VBoxContainer/HBoxContainer/job_name
@onready var job_desc_label : Label = $CanvasLayer/VBoxContainer/HBoxContainer/desc
@onready var job_skill_label : BoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer/BoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():

	display_csv_data( csv_path )
	fill_option_button()
	_on_option_button_item_selected(0)


func load_csv_as_array( csv_path : String) -> Array:
	var _array : Array = []
	
	var file = FileAccess.open (csv_path, FileAccess.READ)
	
	if file == null: 
		printerr( "No CSV found: ", csv_path)
		return _array
	
	while not file.eof_reached():
		var line = file.get_line()
		_array.append( line.split(","))
	
	file.close()
		
	return _array

func display_csv_data( csv_path: String  ):
	data.clear()
		
	data = load_csv_as_array( csv_path )
		
	if data == []:
		return
			
	display_data()
	pass

func clear_data_display() -> void:
	for c in data_display_container.get_children():
		c.queue_free()
		pass
	pass
	
func display_data() -> void:
	var columns : int = data[0].size()
	for d in data:
		var row : HBoxContainer = HBoxContainer.new()
		data_display_container.add_child( row )
	
func create_data_label(value: String ) -> Label:
	var new_label : Label = Label.new()
	new_label.text = value
	new_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return new_label

func fill_option_button():
	for i in range(1, data.size()):
		var row = data[i]
		var id = row[0]
		var job_name = row[1]
		var job_desc = row[2]
		var job_skills = row[3].split(";")
		option_button.add_item(job_name)
		option_button.set_item_metadata(option_button.item_count - 1, {
				"id": id,
				"name": job_name,
				"desc": job_desc,
				"skills": job_skills
			})

func _on_option_button_item_selected(index):
	var meta = option_button.get_item_metadata(index)

	for c in job_skill_label.get_children():
		c.queue_free()

	var skills = meta["skills"]
	for skill in skills:
		var skill_label = Label.new()
		skill_label.text = skill.strip_edges()
		job_skill_label.add_child(skill_label)
	
	job_label.text = str(meta["name"])
	job_desc_label.text = str(meta["desc"])
