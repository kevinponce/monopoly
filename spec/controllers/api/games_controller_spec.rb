require 'rails_helper'

describe Api::GamesController, type: :controller do
  let(:game_params) { attributes_for(:game) }
  let(:user) { create(:user) }

  describe '#create' do
    describe 'not authenticated' do
      before(:each) { post :create, params: { game: game_params } }

      it { expect(response.status).to eq(401) }
    end

    describe 'valid' do
      before(:each) do
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: { game: game_params }

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(200) }
      it { expect(@body['game']).to_not be_empty }
      it { expect(@body['game']['players'].length).to eq(1) }
      it { expect(@body['game']['status']).to eq(Game::Statuses::PENDING) }
    end
  end
end
