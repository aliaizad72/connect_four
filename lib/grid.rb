# frozen_string_literal: true

require 'matrix'

# Grid serves as the playing board of the Game.
class Grid
  attr_accessor :matrix

  def initialize
    @matrix = nil
    create_matrix
  end

  # Connect Four board contains 6 rows and 7 columns
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

  # Matrix is chosen as a method to store Nodes because it allows for easier column access. Furthermore, it is also easier to access each Nodes by using a Matrix rather than a nested array.
  def create_matrix
    array = Array.new(6, [])
    array.each_index do |ind|
      array[ind] = Array.new(7, nil)
    end
    array = Grid.insert_nodes(array)
    @matrix = Matrix[array[0], array[1], array[2], array[3], array[4], array[5]]
  end

  def full?
    @matrix.to_a.flatten.all?(&:color)
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

  def column_full?(column_num)
    result = column(column_num).none? { |node| node.color.nil? }
    puts '  This column is full, try another column.' if result
    result
  end

  def column(column_num)
    @matrix.column(column_num).to_a
  end

  def empty_node_coordinates(column_num)
    empty_node(column_num).coordinates
  end

  def empty_node(column_num)
    column(column_num).find { |node| node.color.nil? }
  end

  def add_token(column_num, color)
    empty_node(column_num).color = color
  end

  # This is the reason why Node was created.
  def four_in_a_row?(coordinates)
    result = false
    node = @matrix[coordinates[0], coordinates[1]]
    # Node.neighbors is a Hashmap, where the key is the direction and the value is the correspoding coordinates of neighbor of Node in that said direction. By calling each_key here, we are able to determine if Node and its neighbors (in any direction), fulfills any one of the winning conditions: node_endpoint_win? or node_midpoint_win?
    node.neighbors.each_key do |direction|
      result = true if node_endpoint_win?(node, direction) || node_midpoint_win?(node, direction)
    end
    result
  end

  # This is a recursive method that checks whether Node, has n neighbors in the direction that was inputted.
  def n_neighbors_in_direction?(node, direction, target_count, count = 0)
    coordinates = node.neighbors[direction]
    return count == target_count if coordinates.nil? # coordinates of nonexistent node

    neighbor = @matrix[coordinates[0], coordinates[1]]
    return count == target_count if neighbor.color.nil? || neighbor.color != node.color || count == target_count

    n_neighbors_in_direction?(neighbor, direction, target_count, count + 1)
  end

  # The first winning condition is if the Node added is an endpoint of four tokens in a row e.g O(here) -> O -> O -> O(or here!). In this case, we only need to check whether node has 3 neighbors in a row, in all directions of it's neighbors.
  def node_endpoint_win?(node, direction)
    n_neighbors_in_direction?(node, direction, 3)
  end

  # The second winning condition is if the Node added is a midpoint of four tokens in a row e.g O -> O(here) -> O(or here) -> O. In this case, there are two different subcases that we need to look into.
  def node_midpoint_win?(node, direction)
    midpoint_case_one(node, direction) || midpoint_case_two(node, direction)
  end

  # The first subcase is if the Node added is if the midpoint is the second Node in a row of four nodes e.g O -> O(here) -> O -> O. In this case, we need to check if node has 2 neighbors in a row in any direction AND if node has 1 neighbor in the CORRESPONDING OPPOSITE DIRECTION. In the example here, it means that the direction should be EAST, and the opposite direction is WEST.
  def midpoint_case_one(node, direction)
    n_neighbors_in_direction?(node, direction, 2) && n_neighbors_in_direction?(node, node.opposite(direction), 1)
  end

  # The second subcase is if the Node added is if the midpoint is the third Node in a row of four nodes e.g O -> O -> O(here) -> O. In this case, we need to check if node has 1 neighbor in any direction AND if node has 2 neighbor in the CORRESPONDING OPPOSITE DIRECTION. In the example here, it means that the direction should be EAST, and the opposite direction is WEST
  def midpoint_case_two(node, direction)
    n_neighbors_in_direction?(node, direction, 1) && n_neighbors_in_direction?(node, node.opposite(direction), 2)
  end
end
