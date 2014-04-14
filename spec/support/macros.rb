def set_current_user(user_id=nil) 
  session[:user_id] = (user_id || Fabricate(:user).id)
end

def current_user
  User.find(session[:user_id])
end

def set_current_admin(user_id=nil)
  session[:user_id] = (user_id || Fabricate(:admin).id)
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def clear_videos
  Video.delete_all
end

def sign_admin_in(an_admin=nil)
  user = an_admin || Fabricate(:admin)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def visit_video_page_from_home(a_video)
  find("a[href='/videos/#{a_video.id}']").click
end