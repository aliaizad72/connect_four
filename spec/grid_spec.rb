# frozen_string_literal: true

require_relative '../lib/node'
require_relative '../lib/grid'

describe Grid do
  describe '.in_grid?' do
    it 'returns true if the coordinates is in the grid' do
      valid_coordinates = [0, 0]
      row = valid_coordinates[0]
      column = valid_coordinates[1]
      result = Grid.in_grid?(row, column)
      expect(result).to be true
    end

    it 'returns false if the coordinates is not in the grid' do
      invalid_coordinates = [-1, 0]
      row = invalid_coordinates[0]
      column = invalid_coordinates[1]
      result = Grid.in_grid?(row, column)
      expect(result).to be false
    end
  end

  describe '#create_matrix' do
    subject(:grid_matrix) { described_class.new }
    it 'creates an outer array of length 6' do
      result = grid_matrix.matrix.length
      expect(result).to eql(6)
    end

    it 'creates an inner array of length 7' do
      matrix = grid_matrix.matrix
      result = matrix.all? { |array| array.length == 7 }
      expect(result).to be true
    end

    it 'all the index are filled with nil values' do
      matrix = grid_matrix.matrix
      result = matrix.all? { |array| array.all?(&:nil?) }
      expect(result).to be true
    end
  end
end
