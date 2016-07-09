class Input
  ORIGIN = /([a-hA-H][1-8])/
  ORIGINTARGET = /([a-hA-H][1-8])([a-hA-H][1-8])/
  COLOR = /(white|black)/

  attr_reader :origin, :target, :color

  def initialize(input)
    @input = input
    parse
  end

  def valid?
    return true unless match.nil?
  end

  def match
    ORIGINTARGET.match(@input) || ORIGIN.match(@input) || COLOR.match(@input)
  end

  def parse
    if match and ["white", "black"].include?(match[1])
      @color = match[1].to_sym
    else
      @origin = match[1] if match
      @target = match[2] if match
    end
  end

end