# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_21_174546) do

  create_table "cards", force: :cascade do |t|
    t.text "description"
    t.string "kind"
    t.string "action"
    t.integer "amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_cards", force: :cascade do |t|
    t.integer "order"
    t.integer "game_id"
    t.integer "card_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_game_cards_on_card_id"
    t.index ["game_id"], name: "index_game_cards_on_game_id"
    t.index ["player_id"], name: "index_game_cards_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "title"
    t.integer "turn", default: 0
    t.integer "jackpot", default: 0
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kp_jwt_tokens", force: :cascade do |t|
    t.string "hashed_token"
    t.string "token_type"
    t.string "entity"
    t.integer "entity_id"
    t.datetime "exp"
    t.boolean "revoked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_token"], name: "index_kp_jwt_tokens_on_hashed_token"
  end

  create_table "places", force: :cascade do |t|
    t.integer "order"
    t.string "kind"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_places_on_property_id"
  end

  create_table "player_properties", force: :cascade do |t|
    t.boolean "mortgaged", default: false
    t.integer "house_count", default: 0
    t.boolean "hotel", default: false
    t.integer "game_id"
    t.integer "player_id"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_player_properties_on_game_id"
    t.index ["player_id"], name: "index_player_properties_on_player_id"
    t.index ["property_id"], name: "index_player_properties_on_property_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "name"
    t.integer "order"
    t.integer "money"
    t.integer "position", default: 0
    t.boolean "in_jail", default: false
    t.integer "roll_out_of_jail_count", default: 0
    t.integer "number_of_doubles", default: 0
    t.integer "game_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.string "kind"
    t.integer "price"
    t.integer "price_per_house"
    t.integer "price_per_hotel"
    t.integer "max_house_count"
    t.integer "can_build_hotel"
    t.integer "rent"
    t.integer "monopoly_rent"
    t.integer "house_rent_1"
    t.integer "house_rent_2"
    t.integer "house_rent_3"
    t.integer "house_rent_4"
    t.integer "hotel_rent"
    t.integer "mortgage_value", null: false
    t.integer "property_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_group_id"], name: "index_properties_on_property_group_id"
  end

  create_table "property_groups", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
