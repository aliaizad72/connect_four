# frozen_string_literal: true

require 'matrix'
require 'colorize'
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
    @neighbors = NEIGHBOR_VECTORS.transform_values { |vector| find_neighbor(vector) }.select { |_k, v| v }
    # selecting non nil neighbors only^^
  end

  def to_s
    "#{coordinates}, neighbors: #{neighbors}"
  end

  def <=>(other)
    coordinates <=> other.coordinates
  end

  def find_neighbor(vector)
    row = @coordinates[0] + vector[0]
    col = @coordinates[1] + vector[1]

    return unless Grid.in_grid?(row, col)

    [row, col]
  end

  def show
    case color
    when 'yellow'
      '🟡'
    when 'blue'
      '🔵'
    else
      '⚪'
    end
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

  def column_full?(column_num)
    column(column_num).none? { |node| node.color.nil? }
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
    neighbor = @matrix[coordinates[0], coordinates[1]]
    return count if neighbor.color.nil? || neighbor.color != node.color || count == 4

    traverse_four(neighbor, direction, count + 1)
  end
end
