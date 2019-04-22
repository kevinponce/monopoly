require 'rails_helper'

describe Api::Games::PlayersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:game) { create(:game, status: Game::Statuses::PENDING) }
  let(:player_params) { { game_id: game.id } }

  describe '#create' do
    describe 'not authenticated' do
      before(:each) { post :create, params: player_params }

      it { expect(response.status).to eq(401) }
    end

    describe 'valid' do
      before(:each) do
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: player_params

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(200) }
      it { expect(@body['game']).to_not be_empty }
      it { expect(@body['game']['players'].length).to eq(1) }
      it { expect(@body['game']['status']).to eq(Game::Statuses::PENDING) }
    end

    describe 'more than one player' do
      let!(:user_2) { create(:user) }
      let!(:player) { create(:player, game: game, user: user_2) }

      before(:each) do
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: player_params

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(200) }
      it { expect(@body['game']).to_not be_empty }
      it { expect(@body['game']['players'].length).to eq(2) }
      it { expect(@body['game']['status']).to eq(Game::Statuses::PENDING) }
    end

    describe 'trying to add again' do
      let!(:player) { create(:player, game: game, user: user) }

      before(:each) do
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: player_params

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(422) }
    end
  end
end
