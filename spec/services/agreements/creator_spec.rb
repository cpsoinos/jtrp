module Agreements
  describe Creator do

    let(:user) { create(:user) }
    let(:proposal) { create(:proposal) }
    let!(:items) do
      %w(sell consign donate dump move undecided).each do |intention|
        create(:item, proposal: proposal, client_intention: intention)
      end
    end

    before do
      allow(PdfGeneratorJob).to receive(:perform_later)
    end

    it "can be instantiated" do
      expect(Agreements::Creator.new(user)).to be_an_instance_of(Agreements::Creator)
    end

    it "creates new agreements" do
      expect{
        Agreements::Creator.new(user).create(proposal)
      }.to change{
        Agreement.count
      }.by(5)

      expect(Agreement.find_by(agreement_type: "undecided")).to be(nil)
    end

    it "finds existing agreements" do
      agreement = create(:agreement, :consign, proposal: proposal)

      expect{
        Agreements::Creator.new(user).create(proposal)
      }.to change {
        Agreement.count
      }.by(4)

      expect(agreement.in?(Agreements::Creator.new(user).create(proposal))).to be(true)
    end

  end
end
