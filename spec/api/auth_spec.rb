describe Crypto::Auth do
  context '#POST api/authentication/register' do
    let(:endpoint) { 'api/authentication/register' }

    context 'with invalid parameters' do
      before { post endpoint, { email: 'te@st', password: 'password', password_confirmation: 't' } }

      it 'returns 422 if passwords do not match' do
        expect(last_response.status).to eq 422
      end
    end

    context 'with valid parameters' do
      let(:user) { build(:user) }

      before { post endpoint, { email: user.email, password: 'test', password_confirmation: 'test' } }

      it 'registers the user' do
        expect(last_response.status).to eq 201

        expect(User.count).to eq 1
        expect(json[:email]).to eq user.email
      end
    end
  end

  context '#POST api/authentication' do
    let(:endpoint) { 'api/authentication' }

    context 'with invalid credentials' do
      before { post endpoint, { email: 'email', password: 'password' } }

      it 'returns 401' do
        expect(last_response.status).to eq 401
      end
    end

    context 'with valid credentials' do
      let(:user) { create(:user) }

      before { post endpoint, { email: user.email, password: 'password' } }

      it 'returns a jwt token' do
        expect(last_response.status).to eq 201
        expect(json).to have_key(:token)
      end
    end
  end
end
