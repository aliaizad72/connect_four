# frozen_string_literal: true

require 'matrix'
# Node is an object that links with other Nodes, in this context it construct the 'spaces' in the Grid
class Node
  include Comparable # included for a test of equality in spec

  # north is -1 on row axis becuase [0, 0] starts at top left, not bottom left
  NEIGHBOR_VECTORS = { north: [1, 0],
                       south: [-1, 0],
                       east: [0, 1],
                       west: [0, -1],
                       north_east: [1, 1],
                       south_east: [-1, 1],
                       south_west: [-1, -1],
                       north_west: [1, -1] }.freeze

  attr_accessor :color
  attr_reader :coordinates, :moves, :neighbors

  def initialize(coordinates)
    @coordinates = coordinates
    @color = nil
    @neighbors = NEIGHBOR_VECTORS.transform_values { |vector| neighbor(vector) }.select { |_k, v| v }
    # selecting non nil neighbors only^^
  end

  def to_s
    case color
    when 'yellow'
      '🟡'
    when 'blue'
      '🔵'
    else
      '⚪'
    end
  end

  def <=>(other)
    coordinates <=> other.coordinates
  end

  def neighbor(vector)
    row = @coordinates[0] + vector[0]
    col = @coordinates[1] + vector[1]

    return unless Grid.in_grid?(row, col)

    [row, col]
  end
end

# Grid is where the game will be played, consists of Nodes that know its neighbours
class Grid
  attr_accessor :matrix

  def initialize
    @matrix = nil # matrix to make it easier for inputting which column player wants to select
    create_matrix # matrix is used as coordinates reference for the nodes
  end

  def self.in_grid?(row, col)
    row >= 0 && row < 6 && col >= 0 && col < 7
  end

  def self.insert_nodes(array)
    array.each_with_index do |row, row_ind|
      row.each_index do |col_ind|
        array[row_ind][col_ind] = Node.new([row_ind, col_ind])
      end
    end
  end

  def create_matrix
    array = Array.new(6, [])
    array.each_index do |ind|
      array[ind] = Array.new(7, nil)
    end
    array = Grid.insert_nodes(array)
    @matrix = Matrix[array[0], array[1], array[2], array[3], array[4], array[5]]
  end

  def add_token(column_num, color)
    unoccupied_node(column_num).color = color
  end

  def unoccupied_node(column_num)
    column(column_num).find { |node| node.color.nil? }
  end

  def empty_node_coordinates(column_num)
    unoccupied_node(column_num).coordinates
  end

  def column_full?(column_num)
    result = column(column_num).none? { |node| node.color.nil? }
    puts 'This column is full, try another column.' if result
    result
  end

  def column(column_num)
    @matrix.column(column_num).to_a
  end

  def full?
    @matrix.to_a.flatten.all?(&:color)
  end

  def four_in_a_row?(coordinates)
    result = false
    node = @matrix[coordinates[0], coordinates[1]]
    node.neighbors.each_key do |direction|
      result = true if traverse_four(node, direction) == 4
    end
    result
  end

  def traverse_four(node, direction, count = 1)
    coordinates = node.neighbors[direction]
    return count if coordinates.nil? || coordinates.empty?

    neighbor = @matrix[coordinates[0], coordinates[1]]
    return count if neighbor.color.nil? || neighbor.color != node.color || count == 4

    traverse_four(neighbor, direction, count + 1)
  end

  def show
    puts <<-HEREDOC

    #{row_seperator}
    #{show_row(5)}
    #{row_seperator}
    #{show_row(4)}
    #{row_seperator}
    #{show_row(3)}
    #{row_seperator}
    #{show_row(2)}
    #{row_seperator}
    #{show_row(1)}
    #{row_seperator}
    #{show_row(0)}
    #{row_seperator}
    | 0️⃣  | 1️⃣  | 2️⃣  | 3️⃣  | 4️⃣  | 5️⃣  | 6️⃣  |
    #{row_seperator}

    HEREDOC
  end

  def row_seperator
    '+----+----+----+----+----+----+----+'
  end

  def show_row(row_num)
    "| #{@matrix[row_num, 0]} | #{@matrix[row_num, 1]} | #{@matrix[row_num, 2]} | #{@matrix[row_num, 3]} | #{@matrix[row_num, 4]} | #{@matrix[row_num, 5]} | #{@matrix[row_num, 6]} |" # rubocop:disable Layout/LineLength
  end
end

# Game handles the logic/flow of the game
class Game
  attr_accessor :players, :grid

  COLORS = %w[blue yellow].shuffle.freeze

  def initialize
    @players = []
    @grid = Grid.new
  end

  def add_players
    2.times { |i| @players.push(Player.new(ask_name(i + 1), COLORS[i])) }
  end

  def ask_name(turn)
    print "Player #{turn}, enter your name: "
    gets.chomp
  end

  def play
    add_players
    announce_colors
    play_round
  end

  def announce_colors
    @players.each(&:tell_color)
  end

  def play_round # rubocop:disable Metrics/MethodLength
    winner = false
    until winner || grid.full?
      @players.each do |player|
        grid.show
        column_num = ask_column(player)
        coordinates = grid.empty_node_coordinates(column_num)
        grid.add_token(column_num, player.color)
        grid.show

        if grid.four_in_a_row?(coordinates)
          winner = true
          announce_winner(player)
          break
        end
      end
    end
  end

  def announce_winner(player)
    puts "#{player.name}, you won!"
  end

  def ask_column(player)
    column_num = player.choose_column
    column_num = player.choose_column while grid.column_full?(column_num)
    column_num
  end
end

# Player contains player node color and their name
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def choose_column
    input = 7
    until input.to_i >= 0 && input.to_i < 7
      print "#{name}, enter the column of your choice: "
      input = gets.chomp
      puts 'ENTER NUMBER FROM 0 TO 6!' if input.to_i.negative? || input.to_i > 6
    end
    input.to_i
  end

  def tell_color
    puts "#{name}, your token colour is #{color}."
  end
end

# ConnectFour: outermost class that user will interact with
class ConnectFour
  def play
    introduction
    game = Game.new
    game.play
  end

  def introduction
    puts "Let's play Connect Four!"
    puts "Your goal in this game is to 'connect' four of your tokens to line up consecutively"
    puts 'in the horizontal, vertical or diagonal direction.'
    puts 'At the start of the game, you will be assigned either the blue token, or the yellow token.'
    puts 'To put your token on the grid, you will need to enter a column number.'
    puts 'The token will fall down to the lowest row in the column that does not contain a token yet.'
    puts "Whoever connects four first, wins! Have fun!\n\n"
  end
end

# ConnectFour.new.play
