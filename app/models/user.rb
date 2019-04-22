# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#

# User model
class User < ActiveRecord::Base
  has_secure_password

  include KpJwt::Model

  validates :email,
            :name, presence: true

  has_many :players
  has_many :games, through: :players
end
