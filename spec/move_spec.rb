describe Move do
  let (:board) { Board.new }

  describe '#initialize' do
    it 'accepts input' do
      m = Move.new(board: board, origin: [0,0], target: [1,1])
      expect(m).not_to be_nil
    end

    it 'sets the attributes' do
      m = Move.new(board: board, origin: [0,0], target: [1,1])
      expect(m.origin).to eq [0,0]
      expect(m.target).to eq [1,1]
    end

    it 'accepts alphanumeric coords' do
      m = Move.new(board: board, origin: "a8", target: "b7")
      expect(m.origin).to eq [0,0]
      expect(m.target).to eq [1,1]
    end

    it 'target param is optional' do
      m = Move.new(board: board, origin: "a8")
      expect(m.origin).to eq [0,0]
      expect(m.target).to be_nil
    end
  end

  describe '#legal?' do
    it 'returns true for legal moves' do
      k = Knight.new(board: board, color: :white, start_pos: [0,0])
      m = Move.new(board: board, origin: [0,0], target: [1,2])
      expect(m.legal?).to be true
    end

    it 'returns false for illegal moves' do
      k = Knight.new(board: board, color: :white, start_pos: [0,0])
      m = Move.new(board: board, origin: [0,0], target: [1,1])
      expect(m.legal?).to be false
    end
  end

  describe '#proceed' do
    it 'moves the piece' do
      k = Knight.new(board: board, color: :white, start_pos: [0,0])
      m = Move.new(board: board, origin: [0,0], target: [1,2])
      m.proceed
      expect(board.occupied? [0,0]).to be false
      expect(board.occupied? [1,2]).to be true
    end
  end

  describe '#available' do
    it 'returns a hash of available moves with special formatting' do
      k = Knight.new(board: board, color: :white, start_pos: [0,0])
      m = Move.new(board: board, origin: 'a8')
      expect(m.possible).to be_a Hash
      expect(m.possible.keys - k.available_moves).to eq([k.current_location])
    end
  end

  describe '#latest_move' do
    it 'returns a hash of the latest move location with special formatting' do
      k = Knight.new(board: board, color: :white, start_pos: [0,0])
      m = Move.new(board: board, origin: [0,0], target: [1,2])
      m.proceed
      expect(m.latest_move).to be_a Hash
      expect(m.latest_move.keys).to eq([k.current_location])
    end
  end
end