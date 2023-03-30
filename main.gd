extends Control

@onready var texture_rect: TextureRect = $Panel/CenterContainer/HBoxContainer/TextureRect
@onready var seed_inp: LineEdit = $Panel/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/SeedINP
@onready var octaves_inp: SpinBox = $Panel/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/OctavesINP
@onready var gain_inp: SpinBox = $Panel/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/GainINP


const image_size := Vector2(512, 512)
const image_format := Image.FORMAT_RGB8
const noise_types: Array = [
	FastNoiseLite.TYPE_SIMPLEX,
	FastNoiseLite.TYPE_SIMPLEX_SMOOTH,
	FastNoiseLite.TYPE_CELLULAR,
	FastNoiseLite.TYPE_PERLIN,
	FastNoiseLite.TYPE_VALUE,
	FastNoiseLite.TYPE_VALUE_CUBIC
]

var noise: = FastNoiseLite.new()
var img := Image.create(image_size.x, image_size.y, false, image_format) 

func _ready():
	randomize()
	
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 1
	noise.fractal_gain = 1
	
	seed_inp.text = str(noise.seed)
	octaves_inp.value = noise.fractal_octaves
	gain_inp.value = noise.fractal_gain

func _process(delta):
	if Input.is_action_pressed("w"):
		noise.offset.y -= 25
	if Input.is_action_pressed("s"):
		noise.offset.y += 25
	if Input.is_action_pressed("a"):
		noise.offset.x -= 25
	if Input.is_action_pressed("d"):
		noise.offset.x += 25
	
	for x in range(0, image_size.x):
		for y in range(0, image_size.y):
			var noise_level = (noise.get_noise_2d(x, y) + 1) / 2
			img.set_pixel(x, y, Color(noise_level, noise_level, noise_level, 1))
	
	texture_rect.texture = ImageTexture.create_from_image(img)

func _on_type_btn_item_selected(index):
	noise.noise_type = noise_types[index]

func _on_seed_inp_text_changed(new_text):
	noise.seed = int(new_text)

func _on_gain_inp_value_changed(value):
	noise.fractal_gain = value

func _on_octaves_inp_value_changed(value):
	noise.fractal_octaves = value
