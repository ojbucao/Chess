class Config
  SETTINGS = {
    1 =>
    { black: [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
              [Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn]],
      white: [[Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn],
              [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]
     },
     2 =>
    { white: [[Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook],
              [Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn]],
      black: [[Pawn, Pawn,   Pawn,   Pawn,  Pawn, Pawn,   Pawn,   Pawn],
              [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]]
     }
  }
end