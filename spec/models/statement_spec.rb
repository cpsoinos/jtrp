describe Statement do

  it { should belong_to(:agreement) }

  describe "state machine" do

    it "starts as 'unpaid'" do
      expect(Statement.new(agreement: build_stubbed(:agreement))).to be_unpaid
    end

    it "transitions 'unpaid' to 'paid'" do
      statement = create(:statement)
      expect(statement).to be_unpaid
      statement.pay
      expect(statement.reload).to be_paid
    end

  end

end
