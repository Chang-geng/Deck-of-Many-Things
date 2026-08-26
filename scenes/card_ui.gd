class_name CardUI

extends Control

@onready var background:Panel=$Background
@onready var label_suit_value:Label=$MarginContainer/VBoxContainer/LabelSuitValue
@onready var label_name:Label=$MarginContainer/VBoxContainer/LabelName
@onready var label_desc:Label=$MarginContainer/VBoxContainer/LabelDesc
var card_data:Card
var is_face_up=true

func setup(card:Card,face_up:bool=true):
	card_data=card
	is_face_up=face_up
	update_display()

func update_display():
	if not is_instance_valid(card_data):
		return
	
	if not is_face_up:
		label_suit_value.text="?"
		label_name.text="[暗牌]"
		label_desc.text="未翻开"
		return
	
	if card_data.is_king or card_data.is_queen:
		var title="国王" if card_data.is_king else "王后"
		label_suit_value.text="JOKER"
		label_name.text=title
		if card_data.is_invalidated:
			label_desc.text="[已作废--0点]"
		else:
			label_desc.text="锁定20点\n要牌自动作废"
			return
	
	var suit_icons=["☀️", "🌙", "⭐", "🌸"]
	var suit_str=suit_icons[card_data.suit]
	label_suit_value.text="%s %d" % [suit_str,card_data.value]
	label_name.text=card_data.card_name if card_data.is_special else ""
	label_desc.text=card_data.description

func _ready() -> void:
	if get_parent() == get_tree().root:
		var test_card = Card.new()
		test_card.suit = Card.Suit.SUN
		test_card.value = 12
		setup(test_card, true)
