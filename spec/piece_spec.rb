require 'piece'

describe Piece do
  describe '.define_movement_methods' do
    it 'takes a move_hash and creates methods from it' do
      expect(described_class).to eq(described_class)
      move_mappings = { up_diagonals:   ['[-x, x]', '[x, x]'] }
      described_class.define_movement_methods(move_mappings)
      moves = described_class.up_diagonals(1)
      expect(moves).to eq([[-1,1], [1,1]])
    end
  end
end