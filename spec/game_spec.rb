# frozen_string_literal: true

require_relative '../lib/main'

describe Game do # rubocop:disable Metrics/BlockLength
  describe '#add_players' do
    subject(:game_add) { described_class.new }
    let(:player_one) { Player.new('Ali', 'blue') }
    let(:player_two) { Player.new('Abu', 'yellow') }

    before do
      allow(Player).to receive(:new).and_return(player_one, player_two)
    end

    it 'sets @players to an array of two players' do
      expected = [player_one, player_two]
      expect { game_add.add_players }.to change { game_add.players }.from([]).to(expected)
    end

    describe '#ask_name' do
      before do
        allow(game_add).to receive(:gets).and_return('Ali')
      end

      it 'returns the user input' do
        turn = 1
        result = game_add.ask_name(turn)
        expect(result).to eql('Ali')
      end
    end
  end

  describe '#ask_column' do
    subject(:game_ask_col) { described_class.new }
    let(:player_one) { Player.new('Ali', 'blue') }
    context 'with the right input' do
      before do
        allow(game_ask_col).to receive(:gets).and_return('2')
      end

      it 'returns the input' do
        input = '2'
        result = game_ask_col.ask_column(player_one)
        expect(result).to eql(input)
      end
    end
  end
end
