package ui;

import ui.GearCard.Requirement;
import openfl.filters.ColorMatrixFilter;
import objects.GameObject;
import scenes.Level;
import openfl.events.MouseEvent;
import openfl.text.TextFormatAlign;
import zero.utilities.Ease;
import zero.utilities.Tween;
import openfl.text.TextField;
import openfl.display.Sprite;
import zero.utilities.Color;
import openfl.events.Event;
import zero.utilities.Vec2;
import ui.PlayingCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using Math;
using util.CardUtil;
using zero.extensions.Tools;

class DropCard extends Card {

	var anchor:Vec2;
	var handle:GearCardHandle;
	var grayscale_filter:ColorMatrixFilter = new ColorMatrixFilter([0.25, 0.25, 0.25, 0, 0, 0.25, 0.25, 0.25, 0, 0, 0.25, 0.25, 0.25, 0, 0, 0, 0, 0, 1, 1]);
	var anchors:Array<Vec2> = [[-35, 28], [35, 28]];
	var cards:Array<PlayingCard> = [];
	var data:DropCardData;
	public var active(default, set):Bool = false;
	function set_active(b:Bool) return active = b && !expended;
	public var expended(default, set):Bool = false;
	function set_expended(b:Bool) {
		filters = b ? [grayscale_filter] : [];
		return expended = b;
	}
	var highlight:Sprite;
	var last:Vec2;

	public function new() {
		super();
		last = [x, y];
		anchor = [0, 0];
	}

	public function verify_card(card_data:PlayingCardData):Bool {
		if (cards.length >= 2) return false;
		switch data.requirement {
			default: return false;
			case MIN_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() >= data.requirement_value || cards.length == 0;
			case MAX_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() <= data.requirement_value;
			case MIN_CARD:
				return card_data.value.value_to_int() >= data.requirement_value;
			case MAX_CARD:
				return card_data.value.value_to_int() <= data.requirement_value;
			case EXACT_CARD:
				return card_data.value.value_to_int() == data.requirement_value;
			case EXACT_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() == data.requirement_value || cards.length == 0;
			case IS_FACE:
				return [JACK, QUEEN, KING].contains(card_data.value);
			case NOT_FACE:
				return ![JACK, QUEEN, KING].contains(card_data.value);
			case PAIR: 
				return cards.length == 0 || cards[0].data.value == card_data.value;
			case NO_MATCH:
				return cards.length == 0 || cards[0].data.value != card_data.value;
			case SAME_SUIT:
				return cards.length == 0 || cards[0].data.suit == card_data.suit;
			case DIFF_SUIT:
				return cards.length == 0 || cards[0].data.suit != card_data.suit;
			case HEARTS:
				return card_data.suit == HEARTS;
			case DIAMONDS:
				return card_data.suit == DIAMONDS;
			case CLUBS:
				return card_data.suit == CLUBS;
			case SPADES:
				return card_data.suit == CLUBS;
			case TWO_CARDS:
				return true;
		}
	}

	public function get_anchor(global:Bool = false):Vec2 {
		return global ? [anchor.x + x, anchor.y + y] : anchor;
	}

	public function add_card(card:PlayingCard) {
		this.add(card);
		cards.push(card);
		card.x -= x;
		card.y -= y;
	}

	public function remove_card(card:PlayingCard) {
		cards.remove(card);
	}

	var t = 0.0;
	function update(e:Event) {
		var i = 0;
		for (card in cards) {
			if (card.dragging) continue;
			card.x += (anchors[i].x - card.x) * 0.25;
			card.y += (anchors[i].y - card.y) * 0.25;
			i++;
		}
		/*if (!dragging && home.length > 0) {
			x += (home.x - x) * 0.1;
			y += (home.y - y) * 0.1;
		}*/
		highlight.visible = active;
		var rot_target = active ? (t += 0.15).sin() * 4 : 0;
		rotation += (rot_target - rotation) * 0.25;
	}

}

typedef DropCardData = {
	requirement:Requirement,
	requirement_value:Int,
}