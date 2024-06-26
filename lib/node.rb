# frozen_string_literal: true

# Node serves as the spaces in the grid, which at any time, can be empty or filled with colors. Node also knows its' neighbors, that is a Node object that is one Node away from itself. There are 8 maximum neighbors to a Node. The rationale for creating Node is to allow Grid to implement a mechanism to determine the winning conditions in a 'tree-traversal-like' manner, rather than having a list of ALL THE COORDINATES OF WINNING CONDITION OF CONNECT FOUR.
class Node
  include Comparable # included for a test of equality in spec

  # north is 1 on row axis becuase [0, 0] starts at bottom left
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

  def neighbor(vector)
    row = @coordinates[0] + vector[0]
    col = @coordinates[1] + vector[1]

    return unless Grid.in_grid?(row, col)

    [row, col]
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

  def opposite(direction)
    { north: :south,
      east: :west,
      south: :north,
      west: :east,
      north_east: :south_west,
      south_east: :north_west,
      south_west: :north_east,
      north_west: :south_east }[direction]
  end

  # included for equality test in spec
  def <=>(other)
    coordinates <=> other.coordinates
  end
end
