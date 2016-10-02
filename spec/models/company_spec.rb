describe Company do

  it_should_behave_like Streamable

  it { should validate_presence_of(:name) }

end
