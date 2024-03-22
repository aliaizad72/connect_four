# frozen_string_literal: true

require_relative '../lib/grid'

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
