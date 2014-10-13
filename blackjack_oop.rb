# OOP version of Blackjack
require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize(s,v)
    @suit = s
    @value = v
  end

  def to_s
    "=> #{value} of #{suit}"
  end

  def drawn
    "=> #{value} of #{suit} *"
  end
end

class Deck
  SUITS = ["Hearts","Diamonds","Spades","Clubs"]
  VALUES = ["Ace",2,3,4,5,6,7,8,9,10,"Jack","Queen","King"]

  attr_accessor :cards

  def initialize(n)
    @cards = []
    n.times do
      SUITS.each do |suit|
        VALUES.each do |face_value|
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
      if card == cards.last && cards.length != 2
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
    puts "=> ???"
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
    puts "Hit(h) or Stand(s)?"
    choice = gets.chomp.downcase
    if choice == 'h' || choice == 'hit'
      "hit"
    elsif choice == 's' || choice == 'stand'
      "stand"    
    else
      "loop"
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
  attr_accessor :bank, :bet_amount, :winnings, :total_winnings 

  def initialize
    puts "What is your name?"
    @name = gets.chomp
    @hand = Hand.new(self)
    @bank = 0
    @bet_amount = 0
    @winnings = 0
    @total_winnings = 0
  end

  def display_buyin_process
    system 'clear'
    puts "Welcome #{name}!"
    puts
    puts "How much are you buying in? ($#{Game::MIN_BET} minimum buy-in)"
    @bank = gets.chomp.to_i
    puts "Buy-in is too low, try again..." if @bank < Game::MIN_BET && @bank != 0
    puts "Invalid buy-in amount, try again..." if @bank == 0
    sleep(1)
  end

  def buy_in
    begin
      display_buyin_process
    end until @bank >= Game::MIN_BET
  end

  def display_bet_process
    system 'clear'
    puts "Let's start the betting process..."
    puts 
    puts "#{name}'s Bank: $#{bank}"
    puts
    puts "How much would you like to bet? (Min: $#{Game::MIN_BET}, Max: $#{Game::MAX_BET})"
    @bet_amount = gets.chomp.to_i
    if (bank - @bet_amount) < 0
      puts "Insufficent funds!"
      sleep(1.5)
    elsif @bet_amount > 100
      puts "Bet is too high, try again..."
      sleep(1.5)
    elsif @bet_amount < 5 && @bet_amount != 0
      puts "Bet is too low, try again..."
      sleep(1.5)
    elsif @bet_amount == 0
      puts "Invalid bet amount, try again..."
      sleep(1.5)
    else
      sleep(1)
    end
  end

  def bet
    begin
      display_bet_process
    end until @bet_amount >= Game::MIN_BET && @bet_amount <= Game::MAX_BET && (bank-@bet_amount) >= 0
    @bank -= @bet_amount if (bank-@bet_amount) >= 0
  end

  def bet_error
    puts "#{name}'s Bank: $#{bank}"
    puts 
    puts "Insufficent funds! You don't have enough to bet!"
    puts
    puts "Buy-in(b) or Quit(q):"
    choice = gets.chomp.downcase
    if choice == 'b' || choice == 'buy' || choice == 'buy-in' || choice == 'buyin'
      buy_in
      bet
    else
      exit
    end
  end

  def show_bet
    puts "#{name}'s Bet: $#{bet_amount}"
    puts
  end

  def show_bank
    puts "#{name}'s Bank: $#{bank}"
  end

  def collect(result="bet")
    case result
    when "bet"
      @winnings = bet_amount
      @bank += winnings
      @total_winnings += @winnings
    when "blackjack"
      @winnings = (bet_amount * 3).to_i
      @bank += winnings
      @total_winnings += @winnings
    when "win"
      @winnings = (bet_amount * 2)
      @bank += winnings
      @total_winnings += @winnings
    end
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
  MIN_BET = 5
  MAX_BET = MIN_BET * 20

  @@rounds = 0

  attr_reader :player, :dealer, :deck

  def initialize
    system 'clear'
    puts "Let's Play Blackjack!"
    puts 
    @deck = Deck.new(1)
    @player = Human.new
    @dealer = Dealer.new
    player.buy_in
  end

  def initial_deal
    2.times do
      player.hand.cards << deck.deal
      dealer.hand.cards << deck.deal
    end
  end

  def display_info_at(sequence)
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
        display_info_at("init_player")
      elsif choice == "loop"
        system 'clear'
        display_info_at("init_player")
      end
    end until choice == "stand" || player.blackjack? || player.bust?
  end

  def dealer_turn
    display_info_at("init_dealer")
    puts "Dealer flips card..."
    sleep(1)
    display_info_at("post_flip")
    unless dealer.reach_17? || dealer.blackjack? || dealer.bust?
      begin
        puts "Dealer hits..."
        sleep(1)
        dealer.hand.cards << deck.deal
        display_info_at("post_flip")
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
      player.collect("blackjack")
      "Blackjack! #{player.name} won $#{player.winnings}!"
    elsif player.bust?
      "Bust! #{player.name} loses $#{player.bet_amount}!"
    elsif dealer.blackjack?
      "Dealer Blackjack! #{player.name} loses $#{player.bet_amount}!"
    elsif dealer.bust?
      player.collect("win")
      "Dealer Bust! #{player.name} won $#{player.winnings}!"
    else
      case compare_hands
      when "tie"
        player.collect
        "It's a tie! You get your bet of $#{player.bet_amount} back!"
      when "#{player.name}"
        player.collect("win")
        "#{player.name} has the larger hand, winning $#{player.winnings}!"
      when "#{dealer.name}"
        "#{dealer.name} has the larger hand, you lose $#{player.bet_amount}!"
      end
    end 
  end

  def announce_result
    system 'clear'
    if player.bust? || player.blackjack?
      display_info_at("init_player")
    elsif dealer.bust? || dealer.blackjack?
      display_info_at("post_flip")
    else
      display_info_at("end_game")
    end
    puts result
    puts
    player.show_bank
  end

  def play_again?
    puts
    puts "Rounds played: #{@@rounds}"
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
    @@rounds += 1
    player.bank >= MIN_BET ? player.bet : player.bet_error
    initial_deal
    display_info_at("init_player")
    unless player.blackjack? || player.bust?
      player_turn
      dealer_turn unless player.blackjack? || player.bust?
    end
    announce_result
    play_again?
  end
end

Game.new.run
