class_name Card   #注册为全局类

extends Resource

enum Suit{SUN,MOON,STAR,FLOWER,JOKER}

var is_invalidated=false
@export var suit:Suit=Suit.SUN
@export var value=1
@export var is_special=false
@export var card_name=""
@export_multiline var description=""
@export var is_king=false
@export var is_queen=false

func get_point_value():
	if is_invalidated:
		return 0
	if is_king or is_queen:
		return 0
	return value
