# frozen_string_literal: true

# Player contains player node color and their name
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def tell_color
    puts "  #{name}, your token colour is #{color}."
  end

  def choose_column # rubocop:disable Metrics/MethodLength
    input = 7
    until input >= 0 && input < 7
      print "  #{name}, enter the column of your choice (0 to 6): "
      input = gets.chomp
      begin
        input = Integer(input)
        puts '  ENTER A NUMBER FROM 0 TO 6!' if input.negative? || input > 6
      rescue ArgumentError
        puts '  Please enter a NUMBER, not a STRING'
        input = 7
      end
    end
    input
  end
end
