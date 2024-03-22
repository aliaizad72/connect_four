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
    it 'creates a matrix with row of length 6' do
      result = grid_matrix.matrix.row_count
      expect(result).to eql(6)
    end

    it 'creates a matrix with with column of length 7' do
      result = grid_matrix.matrix.column_count
      expect(result).to eql(7)
    end

    it 'filled with Node objects' do
      matrix = grid_matrix.matrix.to_a
      result = matrix.all? do |row|
        row.all? { |e| e.is_a? Node }
      end
      expect(result).to be true
    end
  end

  describe '#add_token' do
    context 'it changes the color of that node from nil' do

    end

    describe '#unoccupied_node' do
      subject(:grid_unoccupied) { described_class.new }
      context 'finds an unoccupied node in the selected column' do
        it 'returns the node if column is not full' do
          column_num = 1
          column = grid_unoccupied.matrix.column(column_num).to_a
          node = column[0] # since the subject above does not change the matrix YET
          result = grid_unoccupied.unoccupied_node(column_num)
          expect(result).to equal(node)
        end

        it 'returns nil if column is full' do
          column_num = 1
          grid_unoccupied.matrix.column(column_num).to_a.map { |node| node.color = 'yellow' }
          # for some reason, original matrix can be changed like this^^
          result = grid_unoccupied.unoccupied_node(column_num)
          expect(result).to be_nil
        end
      end
    end
  end
end
