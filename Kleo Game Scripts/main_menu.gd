class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/start_button as Button
@onready var start_button2 = $MarginContainer/HBoxContainer/VBoxContainer/start_button2 as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button as Button
@onready var testworld = load("res://Kleo Game Scenes/testworld.tscn") as PackedScene
@onready var test_dungeon = load("res://Kleo Game Scenes/test_dungeon.tscn") as PackedScene
@onready var music = $music as AudioStreamPlayer


func _process(delta):
	if !music.playing:
		music.play()

func _ready():
	start_button.button_down.connect(start_testworld)
	start_button2.button_down.connect(start_testdungeon)
	exit_button.button_down.connect(leave)

func start_testworld() -> void:
	get_tree().change_scene_to_packed(testworld)

func start_testdungeon() -> void:
	get_tree().change_scene_to_packed(test_dungeon)

func leave() -> void:
	get_tree().quit()
