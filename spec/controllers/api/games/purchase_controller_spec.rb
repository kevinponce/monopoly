require 'rails_helper'

describe Api::Games::PurchaseController, type: :controller do
  let(:position) { 4 }
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user, email: 'other@guy.com') }
  let!(:game) { create(:game, status: Game::Statuses::STARTED) }
  let!(:player) { create(:player, game: game, user: user, order: 0, position: position) }
  let!(:player_2) { create(:player, game: game, user: user_2, order: 1, position: 0) }

  describe '#create' do
    describe 'not authenticated' do
      before(:each) { post :create, params: { game_id: game.id } }

      it { expect(response.status).to eq(401) }
    end

    describe 'game has not started' do
      before(:each) do
        game.update(status: Game::Statuses::PENDING)

        request.headers.merge!({ 'Authorization' => user.create_auth_token })
        post :create,
             params: { game_id: game.id }

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(422) }
      it { expect(@body['message']).to_not be_empty }
    end

    describe 'not players turn' do
      before(:each) do
        game.start!
        request.headers.merge!({ 'Authorization' => user_2.create_auth_token })
        post :create,
             params: { game_id: game.id }

        @body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq(422) }
      it { expect(@body['message']).to_not be_empty }
    end

    describe '#purcahse' do
      describe 'valid' do
        let!(:rail_road) { create(:property, :rail_road) }
        let!(:place) { create(:place, order: position, property: rail_road) }

        before(:each) do
          allow_any_instance_of(Object).to receive(:rand).and_return(1)

          request.headers.merge!({ 'Authorization' => user.create_auth_token })
          post :create,
               params: { game_id: game.id, purcahse: '1' }

          @body = JSON.parse(response.body)
        end

        it { expect(response.status).to eq(200) }
        it { expect(@body['game']).to_not be_empty }
        it { expect(@body['game']['players'].length).to eq(2) }
        it { expect(game.reload.current_player).to eq(player_2) }
      end

      describe 'owned by other player' do
        let!(:rail_road) { create(:property, :rail_road) }
        let!(:place) { create(:place, order: position, property: rail_road) }
        let!(:player_2_property) { create(:player_property, game: game, player: player, property: rail_road) }

        before(:each) do
          allow_any_instance_of(RollService).to receive(:dice).and_return([3, 1])

          request.headers.merge!({ 'Authorization' => user.create_auth_token })
          post :create,
               params: { game_id: game.id, purcahse: '1' }

          @body = JSON.parse(response.body)
        end

        it { expect(response.status).to eq(422) }
        it { expect(@body['message']).to_not be_empty }
      end
    end
  end
end
