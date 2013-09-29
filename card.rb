class Card
  attr_accessor :value, :suit
  
  def initialize(value, suit) 
    @value = value
    @suit = suit
  end
  
  def to_s
    "#{@value[1]}#{@suit[1]}"
  end
end