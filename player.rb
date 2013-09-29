class Player
  attr_accessor :hand, :sum_result
  
  def initialize
    @hand = []
    @sum_result = 0
  end
  
  def pick(choice, card_played, suit_selected)
    choice = choice.to_i
    raise "Pick a card that's there, pick again" unless @hand.length >= choice
    if is_eight?(choice)
      new_card_played = @hand.delete_at(choice-1) 
      return new_card_played
    end
    unless @hand[choice-1].suit[1] == suit_selected or @hand[choice-1].value == card_played.value
      raise "That's not a valid choice"
    end
    new_card_played = @hand.delete_at(choice-1)
  end
  
  def is_eight?(choice)
    @hand[choice-1].value[0] == :eight
  end
  
  def draw_card(card)
    @hand << card
  end
  
  def playable?(card_played, suit_selected)
    @hand.each do |card|
      return true if match?(card, card_played, suit_selected)
    end
    false
  end
  
  def match?(card, card_played, suit_selected)
    return true if card.value == card_played.value or card.suit[1] == suit_selected 
    return true if card.value[0] == :eight
    false
  end
  
  def sum_result 
    result = 0
    @hand.each do |card|
      if '2345679'.include?(card.value[1])
        card_value = card.value[1].to_i
      elsif card.value[1] == 'A'
        card_value = 1
      elsif card.value[1] == '8'
        card_value = 50
      else
        card_value = 10
      end
      result += card_value
    end
    result
  end
end