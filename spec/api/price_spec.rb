describe Crypto::Price do
  context '#GET api/price' do
    let(:endpoint) { 'api/price' }

    context 'when unauthorized' do
      before do
        header 'Authorization', 'Bearer: invalid'
        get endpoint
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

      before do
        header 'Authorization', "Bearer: #{token}"
        expect(Crypto::Services::RedisClient).to receive(:get).and_return 5

        get endpoint
      end

      it 'returns the bitcoin price' do
        expect(json[:bitcoin]).to eq 5
      end
    end
  end
end
