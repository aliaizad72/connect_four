# frozen_string_literal: true

require_relative '../lib/main'

describe Player do
  describe '#choose_column' do
    subject(:player_one) { Player.new('Ali', 'blue') }
    context 'input is an integer' do
      before do
        allow(player_one).to receive(:gets).and_return('2')
      end

      it 'returns the input' do
        input = '2'
        result = player_one.choose_column
        expect(result).to eql(input.to_i)
      end
    end

    context 'inputs are integer, but the first one is not within the range' do
      before do
        allow(player_one).to receive(:gets).and_return('7', '2')
      end

      it 'outputs error prompt once' do
        error_prompt =  '  ENTER A NUMBER FROM 0 TO 6!'
        expect(player_one).to receive(:puts).with(error_prompt).once
        player_one.choose_column
      end
    end

    context 'first input is not an integer' do
      before do
        allow(player_one).to receive(:gets).and_return('7eleven', '2')
      end

      it 'outputs rescue prompt once' do
        rescue_prompt = '  Please enter a NUMBER, not a STRING'
        expect(player_one).to receive(:puts).with(rescue_prompt).once
        player_one.choose_column
      end
    end
  end
end
