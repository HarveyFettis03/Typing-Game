extends Sprite

export (Color) var blue = Color("#4682b4")

export (Color) var green = Color("#639765")

export (Color) var red = Color("#a65455")


onready var prompt = $RichTextLabel
onready var prompt_text = prompt.text

func get_prompt() -> String:
	return prompt_text


func set_next_char_index(next_char_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_char_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(0, next_char_index) + get_bbcode_end_color_tag()
	var red_text = get_bbcode_color_tag(red) + prompt_text.substr(0, next_char_index) + get_bbcode_end_color_tag()
	prompt.parse_bbcode()

func get_bbcode_color_tag(color: Color) -> String:
	return "[color=" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[color]"
