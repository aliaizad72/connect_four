# frozen_string_literal: true

# Node is an object that links with other Nodes, in this context it construct the 'spaces' in the Grid
class Node
  attr_accessor :color
  attr_reader :coordinates, :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west

  def initialize(coordinates)
    @coordinates = coordinates
    @color = nil
    @north = find_neighbor([1, 0])
    @north_east = find_neighbor([1, 1])
    @east = find_neighbor([0, 1])
    @south_east = find_neighbor([-1, 1])
    @south = find_neighbor([-1, 0])
    @south_west = find_neighbor([-1, -1])
    @west = find_neighbor([0, -1])
    @north_west = find_neighbor([1, -1])
  end

  def find_neighbor(vector)
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
    @matrix = nil
    create_matrix # matrix is used as coordinates reference for the nodes
    insert_nodes
  end

  def self.in_grid?(row, col)
    row >= 0 && row <= 6 && col >= 0 && col <= 7
  end

  def create_matrix
    array = Array.new(6, [])
    array.each_index do |ind|
      array[ind] = Array.new(7, nil)
    end
    @matrix = array
  end

  def insert_nodes
    @matrix.each_with_index do |row, row_ind|
      row.each_index do |col_ind|
        @matrix[row_ind][col_ind] = Node.new([row_ind, col_ind])
      end
    end
  end
end
