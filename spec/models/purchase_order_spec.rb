describe PurchaseOrder do

  it { should belong_to(:vendor) }
  it { should belong_to(:created_by) }
  it { should have_many(:items) }

  it { should validate_presence_of(:vendor) }
  it { should validate_presence_of(:created_by) }

end
