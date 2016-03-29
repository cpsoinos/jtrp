feature "add a category" do

  let(:company) { create(:company) }
  let(:user) { create(:user, :internal) }
  let(:consignor) { create(:user, :consignor) }

  context "internal user" do
    scenario "visits categories page" do
      sign_in user
      visit categories_path
    end
  end

end
