describe 'chess' do
  before :each do 
    @b = Board.new
    @b.setup(Config::SETTINGS[1])
  end

  it 'has 32 pieces' do
    expect(@b.pieces.count).to eq(32)
  end

  it 'has 16 white pieces' do
    expect(@b.pieces(:white).count).to eq(16)
  end

  it 'has 16 black pieces' do
    expect(@b.pieces(:black).count).to eq(16)
  end
end