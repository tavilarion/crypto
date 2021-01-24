describe Crypto::Services::NotificationEngine do
  before do
    create(:threshold, user_id: create(:user).id)
  end

  it 'notifies user when threshold exceeds upper limit' do
    expect(Crypto::Services::NotificationClient).to receive(:notify)
    described_class.process(11)
  end

  it 'notifies user when threshold exceeds lower limit' do
    expect(Crypto::Services::NotificationClient).to receive(:notify)
    described_class.process(4)
  end

  it 'does not notify user if threshold is between boundaries' do
    expect(Crypto::Services::NotificationClient).not_to receive(:notify)
    described_class.process(7)
  end
end
