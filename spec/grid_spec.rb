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

  describe '#column_full?' do
    subject(:grid_colfull) { described_class.new }
    it 'returns false if column is not full' do
      result = grid_colfull.column_full?(0)
      expect(result).to be false
    end

    it 'returns true if column is full' do
      grid_colfull.column(0).each { |node| node.color = 'blue' }
      result = grid_colfull.column_full?(0)
      expect(result).to be true
    end

    it 'outputs error prompt when true' do
      grid_colfull.column(0).each { |node| node.color = 'blue' }
      error_prompt = '  This column is full, try another column.'
      expect(grid_colfull).to receive(:puts).with(error_prompt).once
      grid_colfull.column_full?(0)
    end
  end

  describe '#add_token' do
    subject(:grid_add) { described_class.new }
    context 'with spaces in the columns' do
      before do
        column_num = 0
        node = grid_add.column(column_num)[0]
        allow(grid_add).to receive(:empty_node).with(column_num).and_return(node)
      end

      it 'changes the node colour from nil to color' do
        column_num = 0
        color = 'yellow'
        node = grid_add.column(column_num)[0]
        expect { grid_add.add_token(column_num, color) }.to change { node.color }.from(nil).to(color)
      end
    end

    describe '#empty_node' do
      subject(:grid_empty) { described_class.new }
      it 'returns the node if column is not full' do
        column_num = 0
        grid_empty.column(column_num)[0].color = 'blue' # modifying mat so that it is partially full
        node = grid_empty.column(column_num)[1] # 1 is the node that we want since 0 is 'taken'
        result = grid_empty.empty_node(column_num)
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

  describe '#four_in_a_row?' do # rubocop:disable Metrics/BlockLength
    subject(:grid_four) { described_class.new }
    describe '#n_neighbors_in_direction?' do # rubocop:disable Metrics/BlockLength
      context 'a recursive method that counts neighbors in one direction of node until it has count the target counts or reached a deadend' do # rubocop:disable Layout/LineLength
        it 'returns true if target is reached' do
          grid_four.matrix[0, 0].color = 'blue'
          grid_four.matrix[0, 1].color = 'blue'
          node = grid_four.matrix[0, 0]
          target_count = 1
          result = grid_four.n_neighbors_in_direction?(node, :east, target_count)
          expect(result).to equal(true)
        end

        it 'returns false if target is not reached' do
          grid_four.matrix[0, 0].color = 'blue'
          grid_four.matrix[0, 1].color = 'blue'
          node = grid_four.matrix[0, 0]
          target_count = 2
          result = grid_four.n_neighbors_in_direction?(node, :east, target_count)
          expect(result).to equal(false)
        end

        it 'returns false when node is trying to move in direction outside of grid' do
          grid_four.matrix[1, 1].color = 'blue'
          grid_four.matrix[0, 0].color = 'blue'
          node = grid_four.matrix[1, 1]
          target_count = 4
          result = grid_four.n_neighbors_in_direction?(node, :south_west, target_count)
          expect(result).to equal(false)
        end
      end
    end

    describe '#node_endpoint_win?' do
      subject(:grid_endpoint) { described_class.new }
      context 'an endpoint is a node that is at the end of four nodes in a row' do
        it 'returns false if the four nodes is not of the same color' do
          grid_endpoint.matrix[0, 0].color = 'blue'
          grid_endpoint.matrix[0, 1].color = 'blue'
          grid_endpoint.matrix[0, 2].color = 'red'
          grid_endpoint.matrix[0, 3].color = 'blue'
          endpoint = grid_endpoint.matrix[0, 0]
          result = grid_endpoint.node_endpoint_win?(endpoint, :east)
          expect(result).to be false
        end

        it 'returns true if the four nodes is of the same color' do
          grid_endpoint.matrix[0, 0].color = 'blue'
          grid_endpoint.matrix[0, 1].color = 'blue'
          grid_endpoint.matrix[0, 2].color = 'blue'
          grid_endpoint.matrix[0, 3].color = 'blue'
          endpoint = grid_endpoint.matrix[0, 0]
          result = grid_endpoint.node_endpoint_win?(endpoint, :east)
          expect(result).to be true
        end
      end
    end

    describe '#node_midpoint_win?' do # rubocop:disable Metrics/BlockLength
      subject(:grid_midpoint) { described_class.new }
      context 'a midpoint is the second or third node in line of four nodes' do # rubocop:disable Metrics/BlockLength
        describe '#midpoint_case_one' do
          context 'the first win case for midpoint node is when there are 2 nodes in the direction given and 1 node in the opposite direction' do # rubocop:disable Layout/LineLength
            it 'returns false if the four nodes is not of the same color' do
              grid_midpoint.matrix[0, 0].color = 'red'
              grid_midpoint.matrix[0, 1].color = 'blue'
              grid_midpoint.matrix[0, 2].color = 'blue'
              grid_midpoint.matrix[0, 3].color = 'blue'
              midpoint = grid_midpoint.matrix[0, 1]
              result = grid_midpoint.midpoint_case_one(midpoint, :east)
              expect(result).to be false
            end

            it 'returns true if the four nodes is of the same color' do
              grid_midpoint.matrix[0, 0].color = 'blue'
              grid_midpoint.matrix[0, 1].color = 'blue'
              grid_midpoint.matrix[0, 2].color = 'blue'
              grid_midpoint.matrix[0, 3].color = 'blue'
              midpoint = grid_midpoint.matrix[0, 1]
              result = grid_midpoint.midpoint_case_one(midpoint, :east)
              expect(result).to be true
            end
          end
        end

        describe '#midpoint_case_two' do
          context 'the second win case for midpoint node is when there are 1 nodes in the direction given and 2 nodes in the opposite direction' do # rubocop:disable Layout/LineLength
            it 'returns false if the four nodes is not of the same color' do
              grid_midpoint.matrix[0, 0].color = 'blu'
              grid_midpoint.matrix[0, 1].color = 'blue'
              grid_midpoint.matrix[0, 2].color = 'blue'
              grid_midpoint.matrix[0, 3].color = 'red'
              midpoint = grid_midpoint.matrix[0, 2]
              result = grid_midpoint.midpoint_case_two(midpoint, :east)
              expect(result).to be false
            end

            it 'returns true if the four nodes is of the same color' do
              grid_midpoint.matrix[0, 0].color = 'blue'
              grid_midpoint.matrix[0, 1].color = 'blue'
              grid_midpoint.matrix[0, 2].color = 'blue'
              grid_midpoint.matrix[0, 3].color = 'blue'
              midpoint = grid_midpoint.matrix[0, 2]
              result = grid_midpoint.midpoint_case_two(midpoint, :east)
              expect(result).to be true
            end
          end
        end
      end
    end
  end
end
