extends Control

const CARD_UI_SCENE=preload("res://scenes/card_ui.tscn")   #预加载

@onready var game_manager=$GameManager
@onready var p1_hand_container=$MarginContainer/VBoxContainer/P1Area/P1Hand
@onready var p2_hand_container=$MarginContainer/VBoxContainer/P2Area/P2Hand
@onready var label_p1_score=$MarginContainer/VBoxContainer/P1Area/LabelP1Score
@onready var label_p2_score=$MarginContainer/VBoxContainer/P2Area/LabelP2Score
@onready var label_info=$MarginContainer/VBoxContainer/CenterInfo
@onready var check_p1_hit=$MarginContainer/VBoxContainer/ControlArea/CheckP1Hit
@onready var check_p2_hit=$MarginContainer/VBoxContainer/ControlArea/CheckP2Hit
@onready var btn_execute=$MarginContainer/VBoxContainer/ControlArea/BtnExecute

func _ready() -> void:
	btn_execute.pressed.connect(_on_execute_round_pressed)
	check_p1_hit.button_pressed=true
	check_p2_hit.button_pressed=true
	
	update_ui()

func _on_execute_round_pressed():
	if game_manager.is_game_over:
		return
	
	var p1_want=check_p1_hit.button_pressed
	var p2_want=check_p2_hit.button_pressed
	game_manager.execute_turn_round(p1_want,p2_want)
	
	update_ui()
	
func update_ui():
	_render_hand(0,p1_hand_container)
	_render_hand(1,p2_hand_container)
	
	var hand1:Array[Card]=game_manager.player_hands[0]
	var hand2:Array[Card]=game_manager.player_hands[1]
	label_p1_score.text="玩家 1 总点数：%d" % game_manager.calculate_score(hand1)
	label_p2_score.text="玩家 2 总点数：%d" % game_manager.calculate_score(hand2)
	
	if game_manager.player_stood[0]:
		check_p1_hit.button_pressed=false
		check_p1_hit.disabled=true
	if game_manager.player_stood[1]:
		check_p2_hit.button_pressed=false
		check_p2_hit.disabled=true
	
	if game_manager.is_game_over:
		btn_execute.disabled=true
		label_info.text="🏆 对局结束！请查看控制台/总分结果"
	else:
		label_info.text="请勾选双方本轮决策后点击【确认执行】"

func _render_hand(player_id:int,container:HBoxContainer):
	for child in container.get_children():
		child.queue_free()
	var hand:Array[Card]=game_manager.player_hands[player_id]
	for i in range(hand.size()):
		var card=hand[i]
		var card_ui_node=CARD_UI_SCENE.instantiate() as CardUI
		container.add_child(card_ui_node)
		var is_face_up=!(i==0 and player_id==1)
		card_ui_node.setup(card,is_face_up)
