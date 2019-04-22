require 'rails_helper'

describe Api::UserAuthController, type: :controller do
  let(:user_params) { attributes_for(:user) }
  before(:each) { create(:user) }

  describe 'valid' do
    before(:each) { post :create, params: { auth: user_params } }

    it { expect(response.status).to eq(201) }
    it { expect(JSON.parse(response.body)['auth_token']).to_not be_nil }
    it { expect(JSON.parse(response.body)['refresh_token']).to_not be_nil }
  end
end
