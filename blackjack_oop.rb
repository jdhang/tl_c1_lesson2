# OOP version of Blackjack
require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize(s,v)
    @suit = s
    @value = v
  end

  def to_s
    "=> #{value} of #{suit}s"
  end

  def drawn
    "=> #{value} of #{suit}s *"
  end
end

class Deck
  attr_accessor :cards

  def initialize(n)
    @cards = []
    n.times do
      ["Heart","Diamond","Spade","Club"].each do |suit|
        ["Ace",2,3,4,5,6,7,8,9,10,"Jack","Queen","King"].each do |face_value|
          @cards << Card.new(suit,face_value)
        end
      end
    end
    scramble!
  end

  def deal
    cards.pop
  end

  def scramble!
    cards.shuffle!
  end
end

class Hand
  attr_accessor :cards, :name

  def initialize(player)
    @cards = []
    @name = player.name
  end

  def empty
    @cards = []
  end

  def show
    puts "#{name}'s Hand:"
    cards.each do |card|
      if cards.index(card) == (cards.length - 1) && cards.length != 2
        puts card.drawn
      else
        puts card.to_s
      end
    end
    puts "Card Total: #{total}"
    puts
  end

  def show_last
    puts "#{name}'s Hand:"
    cards.each do |card|
      puts card.to_s
    end
    puts "Card Total: #{total}"
    puts
  end

  def show_first
    puts "#{name}'s Hand:"
    puts cards[0]
    puts "???"
    puts "Card Total: ???"
    puts
  end

  def total
    face_cards = ["Jack","Queen","King"]
    total = 0
    ace_count = 0
    cards.each do |card|
      if card.value == "Ace"
        total += 11
        ace_count += 1
      elsif face_cards.include?(card.value)
        total += 10
      else
        total += card.value
      end
    end
    total -= (ace_count * 10) if total > 22
    total
  end
end

class Player
  attr_accessor :name, :hand

  def get_choice
    acceptable = ['h', 'hit', 's', 'stay', 'sur','surrender','sp', 'split', 'dd', 'double down']
    begin
      puts "Hit(h) or Stay(s)?"
      choice = gets.chomp.downcase
    end until acceptable.include?(choice)
    if choice == 'h' || choice == 'hit'
      "hit"
    elsif choice == 's' || choice == 'stay'
      "stay"    
    end
  end

  def blackjack?
    hand.total == 21 ? true : false
  end

  def bust?
    hand.total > 21 ? true : false
  end
end

class Human < Player
  attr_accessor :bank, :bet_amount

  def initialize
    puts "What is your name?"
    @name = gets.chomp
    @hand = Hand.new(self)
    puts
    puts "How much are you buying in? ($)"
    @bank = gets.chomp.to_i
    @bet_amount = 0
  end

  def bet
    puts "Let's start the betting process..."
    begin
      puts 
      puts "#{name}'s Bank: $#{bank}"
      puts
      puts "How much would you like to bet? (Min: 5, Max: 100)"
      @bet_amount = gets.chomp.to_i
      puts "Bet is too high" if @bet_amount > 100
      puts "Bet is too low" if @bet_amount < 5 && @bet_amount != 0
      puts "Invalid Bet amount, try again..." if @bet_amount == 0
      puts "Insufficent funds!" if (bank - @bet_amount) < 0
    end until @bet_amount >= 5 && @bet_amount <= 100 && (bank - @bet_amount) >= 0
    @bank -= @bet_amount if (bank - @bet_amount) >= 0
    system 'clear'
  end

  def show_bet
    puts "#{name}'s Bet: $#{bet_amount}"
    puts
  end

  def show_bank
    puts "#{name}'s Bank: $#{bank}"
  end

  def collect(amount)
    @bank += amount
  end

end

class Dealer < Player

  def initialize
    @name = "Dealer"
    @hand = Hand.new(self)
  end

  def reach_17?
    if hand.total >= 17
      true
    else
      false
    end
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    system 'clear'
    puts "Let's Play Blackjack!"
    puts 
    @deck = Deck.new(1)
    @player = Human.new
    @dealer = Dealer.new
  end

  def initial_deal
    2.times do
      player.hand.cards << deck.deal
      dealer.hand.cards << deck.deal
    end
  end

  def display(sequence)
    system 'clear'
    case sequence
    when "init_player"
      dealer.hand.show_first
      player.hand.show
      player.show_bet
    when "init_dealer"
      dealer.hand.show_first
      player.hand.show_last
      player.show_bet
    when "post_flip"
      dealer.hand.show
      player.hand.show_last
      player.show_bet
    when "end_game"
      dealer.hand.show_last
      player.hand.show_last
      player.show_bet
    end
  end

  def player_turn
    begin
      choice = player.get_choice
      if choice == "hit"
        system 'clear'
        player.hand.cards << deck.deal
        display("init_player")
      end
    end until choice == "stay" || player.blackjack? || player.bust?
  end

  def dealer_turn
    display("init_dealer")
    puts "Dealer flips card..."
    gets
    display("post_flip")
    unless dealer.reach_17? || dealer.blackjack? || dealer.bust?
      begin
        puts "Dealer hits..."
        gets
        dealer.hand.cards << deck.deal
        display("post_flip")
      end until dealer.reach_17? || dealer.blackjack? || dealer.bust?
    end
  end
  
  def compare_hands
    p_total = player.hand.total
    d_total = dealer.hand.total
    if p_total == d_total
      "tie"
    elsif p_total > d_total
      "#{player.name}"
    else
      "#{dealer.name}"
    end 
  end

  def result
    if player.blackjack?
      player.bank += (player.bet_amount * 2.5).to_i
      "Blackjack! #{player.name} won $#{((player.bet_amount*2.5).to_i)}!"
    elsif player.bust?
      "Bust! #{player.name} loses $#{player.bet_amount}!"
    elsif dealer.blackjack?
      "Dealer Blackjack! #{player.name} loses $#{player.bet_amount}!"
    elsif dealer.bust?
      player.bank += (player.bet_amount * 2)
      "Dealer Bust! #{player.name} won $#{(player.bet_amount*2)}!"
    else
      case compare_hands
      when "tie"
        player.bank += player.bet_amount
        "It's a tie! You get your bet of $#{player.bet_amount} back!"
      when "#{player.name}"
        player.bank += (player.bet_amount * 2)
        "#{player.name} has the larger hand, winning $#{(player.bet_amount*2)}!"
      when "#{dealer.name}"
        "#{dealer.name} has the larger hand, you lose $#{player.bet_amount}!"         
      end
    end 
  end

  def announce_result
    system 'clear'
    if player.bust? || player.blackjack?
      display("init_player")
    elsif dealer.bust? || dealer.blackjack?
      display("post_flip")
    else
      display("end_game")
    end
    puts result
    puts
    player.show_bank
  end

  def play_again?
    puts
    puts "Play again? (y/n)"
    exit unless gets.chomp.downcase == 'y'
    reset
    run
  end

  def reset
    system 'clear'
    @player.hand.empty
    @dealer = Dealer.new
  end

  def run
    system 'clear'
    player.bet
    initial_deal
    display("init_player")
    unless player.blackjack? || player.bust?
      player_turn
      dealer_turn unless player.blackjack? || player.bust?
    end
    announce_result
    play_again?
  end
end

Game.new.run