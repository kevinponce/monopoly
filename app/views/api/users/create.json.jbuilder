json.user do
  json.id            @user.id
  json.email         @user.email
  json.auth_token    @user.create_auth_token
  json.refresh_token @user.create_refresh_token
end
