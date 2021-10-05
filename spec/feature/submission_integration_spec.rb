# frozen_string_literal: true

# location: spec/feature/submission_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Viewing a workout post', type: :feature do
  # Include all of the current test fixtures
  fixtures :users, :exercises, :workout_posts, :exercise_posts, :workout_submissions, :exercise_submissions

  scenario 'user can view workout information before they submit' do
    login_as_user

    # i.e. /submissions/new/5
    visit "/submissions/new/#{workout_posts(:wp1).id}"

    # Expect the page to have the title of the workout post
    expect(page).to have_content(workout_posts(:wp1).title.to_s)
  end

  scenario 'user can view exercise information before they submit' do
    login_as_user

    visit "/submissions/new/#{workout_posts(:wp1).id}"

    # Expect the page to have the title of an exercise included in the workout post
    expect(page).to have_content(workout_posts(:wp1).exercise_posts.first.exercise.title)
  end

  scenario 'user can view exercise_post information before they submit' do
    login_as_user

    visit "/submissions/new/#{workout_posts(:wp1).id}"

    # Expect the page to have the specific instructions of an exercise post included in the workout post
    expect(page).to have_content(workout_posts(:wp1).exercise_posts.first.specific_instructions)
  end
end

RSpec.describe 'Submitting to a workout post', type: :feature do
  fixtures :users, :exercises, :workout_posts, :exercise_posts

  # Sunny
  scenario 'user fills in all available fields' do
    login_as_user

    wp = workout_posts(:wp1)

    visit "/submissions/new/#{wp.id}"

    # Fill in all entry boxes
    wp.exercise_posts.each do |ep|
      fill_in "Value for submission (#{ep.exercise.title})", with: 1
    end

    click_on 'Submit'
    expect(page).to have_content('successfully')
  end

  # Rainy
  scenario 'user does not fill in any fields' do
    login_as_user

    wp = workout_posts(:wp1)

    visit "/submissions/new/#{wp.id}"

    click_on 'Submit'

    expect(page).not_to have_content('successfully')
  end
end