describe Crypto::Core do
  before { get 'api/status' }

  it 'returns status and version' do
    expect(last_response.status).to eq 200

    expect(json[:status]).to eq 'ok'
    expect(json[:version]).to eq API_VERSION
  end
end
