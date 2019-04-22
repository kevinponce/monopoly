require 'rails_helper'

describe Api::UsersController, type: :controller do
  let(:user_params) { { user: { email: 'ex@ample.com', password: 'abc123', name: 'example' } } }

  describe 'valid' do
    before(:each) { post :create, params: user_params, format: :json }

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['user']['auth_token']).to_not be_nil }
    it { expect(JSON.parse(response.body)['user']['refresh_token']).to_not be_nil }
  end
end
