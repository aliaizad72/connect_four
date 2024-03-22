# frozen_string_literal: true

# Grid is where the game will be played, consists of Nodes that know its neighbours
class Grid
  attr_accessor :matrix

  def initialize
    @matrix = nil
    create_matrix # matrix is used as coordinates reference for the nodes
  end

  def create_matrix
  end
end
