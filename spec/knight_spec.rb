describe Knight do
  describe '#available_moves' do
    before :each do
      @b = Board.new(size: 3)
      @k = described_class.new(board: @b, color: :white, start_pos: [0, 0])
    end

    context 'when current_location is [0, 0] and board size is 3' do
      it 'has 2 possible moves' do
        moves = @k.available_moves
        expect(moves).to eq([[1, 2], [2, 1]])
      end
    end

    context 'when a location is occupied by an opponent' do
      it 'it includes the opponents location' do
        k2 = described_class.new(board: @b, color: :black, start_pos: [2, 1])
        moves = @k.available_moves
        expect(moves).to contain_exactly([1, 2], [2, 1])
      end
    end

    context 'when a location is occupied by a teammate' do
      it 'excludes the teammates location' do
        k2 = described_class.new(board: @b, color: :white, start_pos: [2, 1])
        moves = @k.available_moves
        expect(moves).to contain_exactly([1, 2])
      end
    end
  end

end