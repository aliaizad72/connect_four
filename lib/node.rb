# frozen_string_literal: true

# Node is an object that links with other Nodes, in this context it construct the 'spaces' in the Grid
class Node
  attr_accessor :color, :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west

  def initialize
    @color = nil
    @north = nil
    @north_east = nil
    @east = nil
    @south = nil
    @south_west = nil
    @west = nil
    @north_west = nil
  end
end
