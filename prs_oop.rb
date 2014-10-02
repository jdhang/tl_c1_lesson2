# Paper Rock Scissor using OOP

class Hand
  attr_accessor :option

  def initialize(o)
    @option = o
  end

  def winning_message
    case @option
    when 'p'
      "Paper covers Rock!"
    when 'r'
      "Rock smashes Scissor!"
    when 's'
      "Scissor cuts Paper!"
    end      
  end
end

class Player
  attr_accessor :name, :hand

  def initialize()
    puts "What is your name?"
    @name = gets.chomp
  end

  def change_name(n)
    @name = n    
  end

  def to_s
    "#{name} picked #{self.hand.option}"
  end

end

class Human < Player
  def pick_hand()
    begin
      puts
      puts "Choose one (P/R/S)"
      choice = gets.chomp.downcase
      self.hand = Hand.new(choice)
    end until Game::CHOICES.keys.include?(choice)
  end
end

class Computer < Player

  def initialize(n)
    @name = n
  end

  def pick_hand()
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game
  CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissor'}

  attr_reader :player, :computer

  def initialize
    puts "Play Paper Rock Scissors!"
    puts
    @player = Human.new
    @computer = Computer.new("Megatron")
  end

  def show_hands
    puts "You picked #{CHOICES[player.hand.option]} and #{computer.name} picked #{CHOICES[computer.hand.option]}"
  end

  def compare_hands
    if player.hand.option == computer.hand.option
      display_winner("tie")
    elsif (player.hand.option == 'r' && computer.hand.option == 's') ||
       (player.hand.option == 'p' && computer.hand.option == 'r') ||
       (player.hand.option == 's' && computer.hand.option == 'p')
      display_winner("player")
    else
      display_winner("computer")
    end
  end

  def display_winner(winner)
    case winner
    when "player"
      puts player.hand.winning_message
      puts "#{player.name} won!"
    when "tie"
      puts "It's a tie!"
    when "computer"
      puts computer.hand.winning_message
      puts "#{computer.name} won!"
    end
  end

  def run
    begin
      player.pick_hand
      computer.pick_hand
      show_hands
      compare_hands
      puts
      puts "Play again? (y/n)"
    end until gets.chomp.downcase != 'y'
  end

end

Game.new.run