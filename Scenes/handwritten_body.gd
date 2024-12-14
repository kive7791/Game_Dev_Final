extends Label

var backstory_text = $".".text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll_text(backstory_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func scroll_text(input_text:String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in text.length():
		visible_characters += 1
		await get_tree().create_timer(0.05).timeout
	
