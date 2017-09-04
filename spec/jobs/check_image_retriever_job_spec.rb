describe CheckImageRetrieverJob do

  let(:check) { create(:check) }

  it "retrieves check images" do
    CheckImageRetrieverJob.perform_later(check_id: check.id)

    expect(check.check_image_front).not_to be_nil
    expect(check.check_image_back).not_to be_nil
  end

end
