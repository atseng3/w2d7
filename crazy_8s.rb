# the game of crazy 8s starts by having a 52 card deck and dealing 5 cards to each player
# (7 if there are only 2 players). The rest of the deck is places face down on the table with 
# last card turned up beside the deck. Starting with the 1st player, each player must either play
# a card matching the suit or the value of the last turned up card or play an 8. If a player plays 
# an 8 she must specify the suit. If the last card is an 8 (with a specified suit) the next player
# must either play an 8 or a card of the specified suit. The first player to get rid of all their 
# cards win, and the rest of the players get penalty points according to the values of their cards.

require './deck'
require './player'

class Game
  attr_accessor :players
  def initialize
    @players = []
    @deck = Deck.new
  end
  
  def play
    # deck deals to all players either 5 or 7 based on @players.count
    deal_to_players
    card_played = @deck.deal
    player_idx = 0
    value_selected = card_played.value[1]
    suit_selected = card_played.suit[1]
    until game_over?
      player_idx = 0 if player_idx == @players.count
      puts "card in play: #{value_selected}#{suit_selected}"
      move = make_move(player_idx, card_played, suit_selected)
      if move == 'd'
        puts "player #{player_idx+1} is drawing a card..."
        draw_card(player_idx, card_played)
        next
      elsif move == 'p'
        new_card_played, suit_selected = take_turn(player_idx, card_played, suit_selected)
        card_played = new_card_played
        value_selected = card_played.value[1]
        player_idx += 1
      end
    end
    show_results
  end
  
  def deal_to_players
    @players.each do |player|
      player.hand << @deck.deal until player.hand.count == (@players.length == 2 ? 7 : 5)
    end
  end
  
  def show_results
    @players.each_with_index do |player, idx|
      if player.hand.empty?
        result = "WINNER!"
      else
        result = player.sum_result
      end
      print "Player#{idx+1}: #{result}\n"
    end
  end
  
  def draw_card(player_idx, card_played)
    new_card = @players[player_idx].draw_card(@deck.deal)
  end
  
  def make_move(player_idx, card_played, suit_selected)
    @players[player_idx].playable?(card_played, suit_selected) ? 'p' : 'd'
  end
  
  def take_turn(player_idx, card_played, suit_selected)
    begin
      choice = prompt(player_idx)
      new_card_played = @players[player_idx].pick(choice, card_played, suit_selected)
      suit_selected = suit_change(new_card_played)
      @deck.return(card_played).shuffle!
    rescue StandardError => e
      puts "Error: #{e.message}"
      retry
    end
      [new_card_played, suit_selected]
  end
  
  def prompt(player_idx)
    puts "Player #{player_idx+1}'s turn: " 
    print @players[player_idx].hand
    puts "\nPick a card to play: (1,2,3,4,5)"
    choice = gets.chomp
  end
  
  def suit_change(new_card_played)
    if new_card_played.value[0] == :eight
      puts "Please pick a suit: ((S)pades, (H)earts, (D)iamonds, (C)lubs)"
      suit_selected = gets.chomp.upcase
    else
      suit_selected = new_card_played.suit[1]
    end
    suit_selected
  end
  
  def add_players(n)
    n.times { |num| @players << Player.new }
  end
  
  def game_over?
    @players.each do |player|
      return true if player.hand.empty?
    end
    false
  end
end