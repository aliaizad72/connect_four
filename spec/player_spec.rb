# frozen_string_literal: true

require_relative '../lib/main'

describe Player do
  describe '#choose_column' do
    subject(:player_one) { Player.new('Ali', 'blue') }
    context 'with the right input' do
      before do
        allow(player_one).to receive(:gets).and_return('2')
      end

      it 'returns the input' do
        input = '2'
        result = player_one.choose_column
        expect(result).to eql(input.to_i)
      end
    end

    context 'with the wrong input once, and the right input after' do
      before do
        allow(player_one).to receive(:gets).and_return('7', '2')
      end

      it 'outputs error prompt once' do
        error_prompt =  '  ENTER NUMBER FROM 0 TO 6!'
        expect(player_one).to receive(:puts).with(error_prompt).once
        player_one.choose_column
      end
    end
  end
end
