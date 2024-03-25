# frozen_string_literal: true

# Game handles the logic/flow of the game
class Game
  attr_accessor :players, :grid

  COLORS = %w[blue yellow].shuffle.freeze

  def initialize
    @players = []
    @grid = Grid.new
  end

  def play
    add_players if @players.empty?
    announce_colors
    play_round
  end

  def add_players
    2.times { |i| @players.push(Player.new(ask_name(i + 1), COLORS[i])) }
  end

  def ask_name(turn)
    print "  Player #{turn}, enter your name: "
    name = gets.chomp
    puts
    name
  end

  def announce_colors
    @players.each(&:tell_color)
  end

  def play_round # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    winner = false
    until winner || grid.full?
      @players.each do |player|
        grid.show
        column_num = ask_column(player)
        coordinates = grid.empty_node_coordinates(column_num)
        grid.add_token(column_num, player.color)

        if grid.four_in_a_row?(coordinates) # rubocop:disable Style/Next
          grid.show
          winner = true
          announce_winner(player)
          break
        end
      end
    end
  end

  def ask_column(player)
    column_num = player.choose_column
    column_num = player.choose_column while grid.column_full?(column_num)
    column_num
  end

  def announce_winner(player)
    puts "  #{player.name}, you won!"
  end

  def reset
    @grid = Grid.new
  end
end
