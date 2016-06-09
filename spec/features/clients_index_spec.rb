# feature "client index" do
#
#   let(:user) { create(:internal_user) }
#   let!(:potential_clients) { create_list(:client, 3, :potential) }
#   let!(:active_clients) { create_list(:client, 3, :active) }
#   let!(:inactive_clients) { create_list(:client, 2, :inactive) }
#   let!(:all_clients) { active_clients | inactive_clients | potential_clients }
#
#   before do
#     sign_in user
#   end
#
#   context "all clients" do
#
#     scenario "visits client list from home page", js: true do
#       visit root_path
#       click_link("Clients")
#       click_link("All Clients")
#
#       expect(page).to have_content("All Clients")
#     end
#
#     scenario "visits client list" do
#       visit clients_path
#
#       expect(page).to have_content("All Clients")
#       all_clients.each do |client|
#         expect(page).to have_link(client.full_name)
#       end
#       expect(page).to have_content("Total proposals:")
#       expect(page).to have_content("Total items:")
#     end
#
#   end
#
#   context "active clients" do
#
#     scenario "visits client list from home page", js: true do
#       visit root_path
#       click_link("Clients")
#       click_link("Active")
#
#       expect(page).to have_content("Active Clients")
#     end
#
#     scenario "visits client list" do
#       visit clients_path(status: 'active')
#
#       expect(page).to have_content("Active Clients")
#       active_clients.each do |client|
#         expect(page).to have_link(client.full_name)
#       end
#       expect(page).to have_content("Total proposals:")
#       expect(page).to have_content("Total items:")
#     end
#
#   end
#
#   context "inactive clients" do
#
#     scenario "visits client list from home page", js: true do
#       visit root_path
#       click_link("Clients")
#       click_link("Inactive")
#
#       expect(page).to have_content("Inactive Clients")
#     end
#
#     scenario "visits client list" do
#       visit clients_path(status: 'inactive')
#
#       expect(page).to have_content("Inactive Clients")
#       inactive_clients.each do |client|
#         expect(page).to have_link(client.full_name)
#       end
#       expect(page).to have_content("Total proposals:")
#       expect(page).to have_content("Total items:")
#     end
#
#   end
#
#   context "potential clients" do
#
#     scenario "visits client list from home page", js: true do
#       visit root_path
#       click_link("Clients")
#       click_link("Potential")
#
#       expect(page).to have_content("Potential Clients")
#     end
#
#     scenario "visits client list" do
#       visit clients_path(status: 'potential')
#
#       expect(page).to have_content("Potential Clients")
#       potential_clients.each do |client|
#         expect(page).to have_link(client.full_name)
#       end
#       expect(page).to have_content("Total proposals:")
#       expect(page).to have_content("Total items:")
#     end
#
#   end
#
# end
