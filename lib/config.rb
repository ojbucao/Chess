module Config
  SETTINGS = {
    :white => { black: [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
                       [Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn]],
                white: [[Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn],
                       [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]
              },
    :black => { white: [[Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook],
                       [Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn]],
                black: [[Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn],
                       [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]]
              }
  }
end
