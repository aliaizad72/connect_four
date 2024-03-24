# frozen_string_literal: true

require_relative '../lib/main'

describe Node do
  describe '#neighbor' do
    subject(:node_middle) { described_class.new([4, 4]) }
    subject(:node_corner) { described_class.new([0, 0]) }
    context 'given a coordinate and a vector' do
      it 'returns the neighbor coordinate if it exist in the grid' do
        north_neighbor = [5, 4]
        expect(node_middle.neighbors[:north]).to eql(north_neighbor)
      end

      it 'returns nil if coordinate does not exist in the grid' do
        _south_neighbor = [-1, 0]
        expect(node_corner.neighbors[:south]).to be_nil
      end
    end
  end

  describe '#opposite' do
    subject(:node_opposite) { described_class.new([4, 4]) }
    it 'returns a symbol of an opposite direction given a direction' do
      direction = :north
      opposite_direction = :south
      result = node_opposite.opposite(direction)
      expect(result).to eq(opposite_direction)
    end
  end
end
