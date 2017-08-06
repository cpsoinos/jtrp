describe AccountStateMachine do

  it "starts as 'potential'" do
    expect(Account.new).to be_potential
  end

  it "transitions 'potential' to 'active'" do
    account = create(:account)
    create(:job, :active, account: account)
    account.mark_active

    expect(account).to be_active
  end

  it "transitions 'active' to 'completed'" do
    account = create(:account, :active)
    create(:job, :completed, account: account)
    account.mark_inactive

    expect(account).to be_inactive
  end

  it "transitions 'potential' to 'inactive'" do
    item = create(:item)
    account = item.account
    account.mark_inactive!

    expect(account.reload).to be_inactive
    expect(item.reload).to be_inactive
  end

  it "transitions 'inactive' to 'active'" do
    account = create(:account, :inactive)
    account.reactivate!

    expect(account).to be_active
  end

end
