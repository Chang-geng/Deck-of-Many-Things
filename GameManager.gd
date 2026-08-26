extends Node

var deck: Deck
var player_hands: Array[Array] = []
var player_busted: Array[bool] = [false, false]
var player_stood: Array[bool] = [false, false]
var is_game_over: bool = false

func _ready() -> void:
	deck = Deck.new()
	deck.initialize_deck()
	start_game()

func start_game():
	print("========== 21点对局开始 ==========")
	var hand1: Array[Card] = []
	var hand2: Array[Card] = []
	player_hands = [hand1, hand2]
	
	player_busted = [false, false]
	player_stood = [false, false]
	is_game_over = false
	
	for i in range(2):
		var dark_card = deck.draw_card()
		var light_card = deck.draw_card()
		player_hands[i].append(dark_card)
		player_hands[i].append(light_card)
		print("玩家 %d 发牌完毕！明牌为：%s" % [i + 1, get_card_string(light_card)])

	for i in range(2):
		if calculate_score(player_hands[i]) > 21:
			player_busted[i] = true
			print("💥 玩家 %d 开局爆牌！" % (i + 1))
			
	if player_busted[0] or player_busted[1]:
		_resolve_game()

func execute_turn_round(p1_wants_hit: bool, p2_wants_hit: bool):
	if is_game_over:
		print("❌ 对局已结束，无法继续操作！")
		return

	if player_stood[0]: 
		p1_wants_hit = false
	if player_stood[1]: 
		p2_wants_hit = false

	if not p1_wants_hit and not player_stood[0]:
		player_stood[0] = true
		print("✋ 玩家 1 选择停牌，后续不能再要牌！")
	if not p2_wants_hit and not player_stood[1]:
		player_stood[1] = true
		print("✋ 玩家 2 选择停牌，后续不能再要牌！")

	if p1_wants_hit:
		_draw_card_for_player(0)
	if p2_wants_hit:
		_draw_card_for_player(1)

	if player_busted[0] or player_busted[1]:
		_resolve_game()
		return

	if player_stood[0] and player_stood[1]:
		_resolve_game()

func _draw_card_for_player(player_id: int):
	var hand: Array[Card] = player_hands[player_id]
	
	for card in hand:
		if (card.is_king or card.is_queen) and not card.is_invalidated:
			card.is_invalidated = true
			print("⚠️ 玩家 %d 王牌作废！" % (player_id + 1))
			
	var new_card = deck.draw_card()
	hand.append(new_card)
	print(" 发给玩家 %d 一张牌：%s" % [player_id + 1, get_card_string(new_card)])
	
	var current_score = calculate_score(hand)
	print("  └─ 玩家 %d 当前总点数：%d" % [player_id + 1, current_score])
	
	if current_score > 21:
		player_busted[player_id] = true
		print("💥 玩家 %d 爆牌！" % (player_id + 1))

func calculate_score(hand: Array[Card]) -> int:
	var has_active_joker = false
	var total = 0
	
	for card in hand:
		if (card.is_king or card.is_queen) and not card.is_invalidated:
			has_active_joker = true
		else:
			total += card.get_point_value()
	if has_active_joker:
		return 20
	
	return total

func get_card_string(card: Card) -> String:
	if card.is_king:
		return "[国王]"
	if card.is_queen:
		return "[王后]"
		
	var suit_name = ""
	match card.suit:
		Card.Suit.SUN: suit_name = "太阳☀️"
		Card.Suit.MOON: suit_name = "月亮🌙"
		Card.Suit.STAR: suit_name = "星辰⭐"
		Card.Suit.FLOWER: suit_name = "花朵🌸"
		
	return suit_name + str(card.value)

func _resolve_game():
	if is_game_over:
		return
	is_game_over = true
	
	print("\n========== 本局比赛结束，进行结算 ==========")
	var hand1: Array[Card] = player_hands[0]
	var hand2: Array[Card] = player_hands[1]
	var p1_score = calculate_score(hand1)
	var p2_score = calculate_score(hand2)
	var p1_bust = player_busted[0]
	var p2_bust = player_busted[1]
	print("玩家 1 最终得分：%d %s" % [p1_score, "(爆牌)" if p1_bust else ""])
	print("玩家 2 最终得分：%d %s" % [p2_score, "(爆牌)" if p2_bust else ""])

	if p1_bust and p2_bust:
		print("🏆 双方同时爆牌，【平局】！")
	elif p1_bust:
		print("🏆 玩家 1 爆牌，【玩家 2 直接获胜】！")
	elif p2_bust:
		print("🏆 玩家 2 爆牌，【玩家 1 直接获胜】！")
	else:
		if p1_score > p2_score:
			print("🏆 【玩家 1 获胜】！")
		elif p2_score > p1_score:
			print("🏆 【玩家 2 获胜】！")
		else:
			print("🏆 双方点数相同，【平局】！")
