class Input
  ORIGIN = /([a-hA-H][1-8])/
  ORIGINTARGET = /([a-hA-H][1-8])([a-hA-H][1-8])/

  attr_reader :origin, :target

  def initialize(input)
    @input = input
    parse
  end

  def valid?
    return true unless match.nil?
  end

  def match
    ORIGINTARGET.match(@input) || ORIGIN.match(@input)
  end

  def parse
    @origin = match[1] if match
    @target = match[2] if match
  end

end