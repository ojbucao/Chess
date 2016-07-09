require_relative 'player'

class Human < Player

  def input
    Input.new(@interface.get_input)
  end

end