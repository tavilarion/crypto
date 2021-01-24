describe Crypto::Thresholds do
  context '#POST api/thresholds' do
    let(:endpoint) { 'api/thresholds' }

    context 'when unauthorized' do
      before do
        header 'Authorization', 'Bearer: invalid'
        post endpoint, lower: 12, upper: 14
      end

      it 'returns 401' do
        expect(last_response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:token) do
        post 'api/authentication', email: user.email, password: 'password'
        json[:token]
      end
      let(:lower) { '10.0001' }
      let(:upper) { '12.11001' }

      before do
        header 'Authorization', "Bearer: #{token}"
      end

      it 'creates threshold entry' do
        expect(Crypto::Services::NotificationEngine).to receive(:check)
        post endpoint, lower: lower, upper: upper

        expect(last_response.status).to eq 201

        expect(Threshold.count).to eq 1
        expect(json[:lower]).to eq lower
        expect(json[:upper]).to eq upper
      end

      it 'notifies user if lower threshold exceeded' do
        expect(Crypto::Services::RedisClient).to receive(:get).and_return 10
        expect(Crypto::Services::NotificationClient).to receive(:notify)

        post endpoint, lower: lower, upper: upper
      end

      it 'notifies user if upper threshold exceeded' do
        expect(Crypto::Services::RedisClient).to receive(:get).and_return 12.12
        expect(Crypto::Services::NotificationClient).to receive(:notify)

        post endpoint, lower: lower, upper: upper
      end
    end
  end
end
