include ApplicationHelper

def valid_signin( user )
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector "div.alert.alert-error", text: message
  end
end

RSpec::Matchers.define :have_error_message_point do |message|
  match do |page|
    page.should have_selector "li", text: message
  end
end

RSpec::Matchers.define :have_page_title do |title|
  match do |page|
    page.should have_selector "title", text: title
  end
end

RSpec::Matchers.define :have_title do |title|
  match do |page|
    page.should have_selector "h1", text: title
  end
end
