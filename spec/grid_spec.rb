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
    subject(:grid_add) { described_class.new }
    context 'with spaces in the columns' do
      before do
        column_num = 0
        node = grid_add.column(column_num)[0]
        allow(grid_add).to receive(:unoccupied_node).with(column_num).and_return(node)
      end

      it 'changes the node colour from nil to color' do
        column_num = 0
        color = 'yellow'
        node = grid_add.column(column_num)[0]
        expect { grid_add.add_token(column_num, color) }.to change { node.color }.from(nil).to(color)
      end
    end

    describe '#unoccupied_node' do
      subject(:grid_unoccupied) { described_class.new }
      it 'returns the node if column is not full' do
        column_num = 0
        grid_unoccupied.column(column_num)[0].color = 'blue' # modifying mat so that it is partially full
        node = grid_unoccupied.column(column_num)[1] # 1 is the node that we want since 0 is 'taken'
        result = grid_unoccupied.unoccupied_node(column_num)
        expect(result).to equal(node)
      end
    end
  end

  describe '#full?' do
    subject(:grid_full) { described_class.new }
    it 'returns true when the matrix is full' do
      # populate node matrix with color
      grid_full.matrix.to_a.flatten.each { |node| node.color = 'blue' }
      result = grid_full.full?
      expect(result).to be true
    end

    it 'returns false when the matrix is not full' do
      # populate just a column with color
      grid_full.column(1).each { |node| node.color = 'red' }
      result = grid_full.full?
      expect(result).to be false
    end
  end
end
