# frozen_string_literal: true

require_relative '../lib/main'

describe Grid do # rubocop:disable Metrics/BlockLength
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

  describe '.insert_nodes' do
    it 'maps n x n array with Node objects' do
      array = [[nil, nil], [nil, nil]]
      mapped = [[Node.new([0, 0]), Node.new([0, 1])], [Node.new([1, 0]), Node.new([1, 1])]]
      result = Grid.insert_nodes(array)
      expect(result).to eq(mapped)
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

    it 'filled with Node objects' do
      matrix = grid_matrix.matrix
      result = matrix.all? do |row|
        row.all? { |e| e.is_a? Node }
      end
      expect(result).to be true
    end
  end
end
