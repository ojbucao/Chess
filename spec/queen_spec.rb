require 'queen'

describe Queen do
  describe 'MOVEMENTS constant' do
    it 'is not nil' do
      m = described_class::MOVEMENTS
      expect(m).not_to be_nil
      expect(m.count).to eq(64)
    end
  end

  describe '#possible_moves' do
    context 'when current_location is [1,1]' do
      it 'has 20 possible moves' do
        b = Board.new(size: 3)
        q = described_class.new(board: b)
        q.current_location = [1, 1]
        moves = q.possible_moves
        expect(moves).to contain_exactly([0, 0], [0, 1], [0, 2], 
                                         [1, 0], [1, 2], [2, 0], 
                                         [2, 1], [2, 2])
      end
    end
  end

end