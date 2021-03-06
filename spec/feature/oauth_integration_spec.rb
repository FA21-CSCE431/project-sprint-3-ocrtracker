# frozen_string_literal: true

# location: spec/feature/oauth_integration_spec.rb
require 'rails_helper'

RSpec.describe 'OAuth login', type: :feature do
  fixtures :users

  scenario 'defualt page for valid email' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'john.doe@tamu.edu'
    visit '/'
    expect(page).to have_content('Sign in with Google')
  end

  scenario 'default page for invalid email' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'john.doe@gmail.com'
    visit '/'
    expect(page).to have_content('Sign in with Google')
  end

  scenario 'should create a new user with an @tamu.edu email' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'john.doe@tamu.edu'
    visit '/'
    click_on 'Sign in with Google'
    expect(page).to have_content('Welcome')
  end

  scenario 'should not create a new user with an email other than @tamu.edu' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'john.doe@gmail.com'
    visit '/'
    click_on 'Sign in with Google'
    expect(page).to have_content('is not authorized')
  end

  scenario 'user attempts to access a page without signing in first' do
    visit '/'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end
end

RSpec.describe 'Safegaurd login', type: :feature do
  fixtures :users
  scenario 'should only allow tamuocr@gmail.com email through' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'tamuocr@gmail.com'
    visit '/'
    click_on 'Sign in with Google'
    expect(page).to have_content('Welcome')
  end
end

RSpec.describe 'Admin vs User access', type: :feature do
  fixtures :users
  scenario 'admin logs in' do
    login_as_admin
    visit '/'
    expect(page).to have_content('admin')
  end

  scenario 'user logs in' do
    login_as_user
    visit '/'
    expect(page).to have_content('user')
  end
end

RSpec.describe 'OAuth logout', type: :feature do
  fixtures :users
  scenario 'user logs out' do
    OmniAuth.config.mock_auth[:google_oauth2].info.email = 'john.doe@tamu.edu'
    visit user_google_oauth2_omniauth_authorize_path
    visit destroy_user_session_path
    expect(page).to have_content('Signed out successfully')
  end
end
