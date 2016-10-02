describe StatementJob do

  let!(:agreements) { create_list(:agreement, 3, :active, :consign) }

  it "perform" do
    expect {
      StatementJob.perform_later
    }.to change {
      Statement.count
    }.by (3)
  end

end
