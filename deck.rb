require './card'

class Deck
  attr_reader :cards
  
  SUIT_STRINGS = { 
    :clubs    => "C", 
    :diamonds => "D", 
    :hearts   => "H", 
    :spades   => "S" 
  }
  
  VALUE_STRINGS = {
    :two   => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
  }
  
  def initialize
    create_deck
  end
  
  def create_deck
    @cards = []
    SUIT_STRINGS.each do |suit|
        VALUE_STRINGS.each { |value| @cards << Card.new(value, suit) }
    end
    @cards.shuffle!
  end
  
  def deal
    @cards.pop
  end
  
  def return(card)
    @cards.unshift(card)
  end
end