describe Job do

  it { should belong_to(:account) }
  it { should have_many(:proposals) }
  it { should have_many(:items).through(:proposals) }

  it { should validate_presence_of(:account) }

  # describe Job, "state_machine" do
  #   let(:account) { create(:account) }
  #
  #   it "starts as 'potential'" do
  #     expect(Job.new.status).to eq("potential")
  #   end
  #
  #   it "transitions 'potential' to 'active'" do
  #     job = create(:job)
  #
  #     expect(job.status).to eq("active")
  #   end
  #
  #   it "transitions 'active' to 'sold'" do
  #     item = create(:item, :active, client_intention: "sell")
  #     item.mark_sold!
  #
  #     expect(item.status).to eq("sold")
  #   end
  #
  # end

end
