# frozen_string_literal: true

require_relative '../lib/main'

describe Game do # rubocop:disable Metrics/BlockLength
  describe '#play' do # rubocop:disable Metrics/BlockLength
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

    describe '#play_round' do
      describe '#ask_column' do
        subject(:game_column) { described_class.new }
        let(:player_one) { Player.new('Ali', 'blue') }
        context 'if column is not full' do
          before do
            grid = game_column.grid
            allow(grid).to receive(:column_full?).and_return(false)
          end

          it 'sends #choose_column once' do
            expect(player_one).to receive(:choose_column).once
            game_column.ask_column(player_one)
          end
        end

        context 'if column if full, ask again' do
          before do
            grid = game_column.grid
            allow(grid).to receive(:column_full?).and_return(true, false)
          end

          it 'sends #choose_column twice' do
            expect(player_one).to receive(:choose_column).twice
            game_column.ask_column(player_one)
          end
        end
      end
    end
  end
end
