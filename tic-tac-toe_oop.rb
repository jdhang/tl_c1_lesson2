# OOP version of Tic-Tac-Toe
class Board
  WIN = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  attr_accessor :spaces

  def initialize
    @spaces = {}
    (1..9).each{|position| @spaces[position] = " "}
  end

  def empty_spaces
    @spaces.keys.select{|position| @spaces[position] == " "}
  end

  def valid_space?(key)
    if @spaces.has_key?(key)
      true
    else
      false
    end
  end

  def empty_space?(key)
    if empty_spaces.include?(key)
      true
    else
      false
    end
  end

  def winner?
    WIN.each do |line|
      if @spaces.values_at(*line).count("X") == 3
        return "human"
      elsif @spaces.values_at(*line).count("O") == 3
        return "computer"
      elsif empty_spaces == []
        return "tie"
      end
    end
    false
  end

  def display_error(position)
    if !(valid_space?(position))
      puts
      puts "ERROR: Invalid position, try again!"
      puts
    elsif !(empty_space?(position))
      puts
      puts "ERROR: Position is taken, choose another one!"
      puts
    end
  end

  def display
    system 'clear'
    row = "     |     |     "
    boundary = "-----+-----+-----"
    one_to_three = "  #{@spaces[1]}  |  #{@spaces[2]}  |  #{@spaces[3]}  "
    four_to_six = "  #{@spaces[4]}  |  #{@spaces[5]}  |  #{@spaces[6]}  "
    seven_to_nine = "  #{@spaces[7]}  |  #{@spaces[8]}  |  #{@spaces[9]}  "

    board_arr = [" ", row, one_to_three, row, boundary, row, four_to_six, row,
           boundary, row, seven_to_nine, row, " "]
    board_arr.each {|i| puts i}
  end

end

class Player
  attr_accessor :name

  def initialize(n)
    @name = n
  end

end

class Human < Player

  def initialize
    puts "What is your name?"
    @name = gets.chomp
  end

  def place_piece(board)
    board.display
    begin
      puts "Choose a position (from 1 to 9) to place a piece:"
      position = gets.chomp.to_i
      board.display_error(position)
    end until board.valid_space?(position) && board.empty_space?(position)
    board.spaces[position] = "X"
  end
end

class Computer < Player
  def place_piece(board)
    board.spaces[board.empty_spaces.sample] = "O"
  end
end

class Game
  attr_reader :player, :computer, :board

  def initialize
    puts "Play Tic-Tac-Toe!"
    puts
    @player = Human.new
    @computer = Computer.new("Megatron")
  end

  def annouce_winner(board)
    board.display
    winner = board.winner?
    case winner
    when 'human'
      puts "#{player.name} won!"
    when 'computer'
      puts "#{computer.name} won!"
    when 'tie'
      puts "It's a tie!"
    end
  end

  def run
    begin
      @board = Board.new
      begin
        player.place_piece(board)
        computer.place_piece(board) unless board.winner?
      end until board.winner?
      annouce_winner(board)
      puts
      puts "Play again? (y/n)"
    end until gets.chomp.downcase != 'y'
  end
end

Game.new.run