# frozen_string_literal: true

require 'matrix'
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
    puts '  This column is full, try another column.' if result
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
      result = true if node_endpoint_win?(node, direction) || node_midpoint_win?(node, direction)
    end
    result
  end

  def n_neighbors_in_direction?(node, direction, target_count, count = 0)
    coordinates = node.neighbors[direction]
    return count == target_count if coordinates.nil? # coordinates of nonexistent node

    neighbor = @matrix[coordinates[0], coordinates[1]]
    return count == target_count if neighbor.color.nil? || neighbor.color != node.color || count == target_count

    n_neighbors_in_direction?(neighbor, direction, target_count, count + 1)
  end

  def node_endpoint_win?(node, direction)
    n_neighbors_in_direction?(node, direction, 3)
  end

  def node_midpoint_win?(node, direction)
    midpoint_case_one(node, direction) || midpoint_case_two(node, direction)
  end

  def midpoint_case_one(node, direction)
    n_neighbors_in_direction?(node, direction, 2) && n_neighbors_in_direction?(node, node.opposite(direction), 1)
  end

  def midpoint_case_two(node, direction)
    n_neighbors_in_direction?(node, direction, 1) && n_neighbors_in_direction?(node, node.opposite(direction), 2)
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
