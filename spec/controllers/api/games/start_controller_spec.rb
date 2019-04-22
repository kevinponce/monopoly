require 'rails_helper'

describe Api::Games::StartController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:game) { create(:game, status: Game::Statuses::PENDING) }
  let!(:player) { create(:player, game: game, user: user) }
  let!(:player_2) { create(:player, game: game, user: user_2) }

  describe '#create' do
    describe 'not authenticated' do
      before(:each) { post :create, params: { game_id: game.id } }

      it { expect(response.status).to eq(401) }
    end

    describe 'valid' do
      before(:each) do
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: { game_id: game.id }

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(200) }
      it { expect(@body['game']).to_not be_empty }
      it { expect(@body['game']['players'].length).to eq(2) }
      it { expect(@body['game']['status']).to eq(Game::Statuses::STARTED) }
    end


    describe 'already started' do
      before(:each) do
        game.start!
        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: { game_id: game.id }

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(422) }
      it { expect(@body['message']).to_not be_empty }
    end
  end
end
