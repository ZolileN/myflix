def set_current_user(user_id=nil) 
  session[:user_id] = (user_id || Fabricate(:user).id)
end

def current_user
  User.find(session[:user_id])
end
