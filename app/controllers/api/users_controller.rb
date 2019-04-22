# frozen_string_literal: true

# handles api endpoint for managing users
class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    unless @user.save
      render status: 401, json: { message: @user.errors.full_messages.to_sentence }
    end
  end

  private

  def user_params
    params.required(:user).permit(:email, :password, :name)
  end
end
