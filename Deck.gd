class_name Deck

extends Node

var cards:Array[Card]=[]

func initialize_deck():
	cards.clear()
	for s in [Card.Suit.SUN,Card.Suit.MOON,Card.Suit.STAR,Card.Suit.FLOWER]:
		for v in range(1,14):
			var card=Card.new()
			card.suit=s
			card.value=v
			cards.append(card)
			
	var king_card=Card.new()
	king_card.suit=Card.Suit.JOKER
	king_card.is_king=true
	cards.append(king_card)
	
	var queen_card=Card.new()
	queen_card.suit=Card.Suit.JOKER
	queen_card.is_queen=true
	cards.append(queen_card)
	cards.shuffle()   #把数组中元素随机打乱

func draw_card():
	if cards.is_empty():
		initialize_deck()
	return cards.pop_back()   #把数组末尾元素拿出来
