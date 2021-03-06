# frozen_string_literal: true

# location: spec/feature/exercise_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Creating an exercise', type: :feature do
  fixtures :users

  scenario 'valid title' do
    login_as_admin
    visit exercises_path
    click_on 'New Exercise'
    fill_in 'Title', with: 'test_title'
    fill_in 'Description', with: 'test_desc'
    select Exercise.unit_names.values.first, from: 'Unit name'
    click_on 'Submit'
    expect(page).to have_content('test_title')
  end

  scenario 'valid description' do
    login_as_admin
    visit exercises_path
    click_on 'New Exercise'
    fill_in 'Title', with: 'test_title'
    fill_in 'Description', with: 'test_desc'
    select Exercise.unit_names.values.first, from: 'Unit name'
    click_on 'Submit'
    expect(page).to have_content('test_desc')
  end

  scenario 'valid unit name' do
    login_as_admin
    visit exercises_path
    click_on 'New Exercise'
    fill_in 'Title', with: 'test_title'
    fill_in 'Description', with: 'test_desc'
    select Exercise.unit_names.values.first, from: 'Unit name'
    click_on 'Submit'
    expect(page).to have_content(Exercise.unit_names.values.first)
  end

  scenario 'non-admin user' do
    login_as_user
    visit exercises_path
    expect(page).to have_current_path root_path, ignore_query: true
  end

  scenario 'invalid inputs' do
    login_as_admin
    visit exercises_path
    click_on 'New Exercise'
    click_on 'Submit'
    expect(page).to have_content('error')
  end
end

RSpec.describe 'Editing an exercise', type: :feature do
  fixtures :users, :exercises

  scenario 'valid inputs' do
    login_as_admin
    visit edit_exercise_path(exercises(:pushups))
    fill_in 'Title', with: 'new_test_title'
    fill_in 'Description', with: 'new_test_desc'
    select Exercise.unit_names.values.first, from: 'Unit name'
    click_on 'Submit'
    expect(page).to have_current_path exercise_path(exercises(:pushups)), ignore_query: true
  end

  scenario 'invalid inputs' do
    login_as_admin
    visit edit_exercise_path(exercises(:pushups))
    fill_in 'Title', with: ''
    click_on 'Submit'
    expect(page).to have_content 'error'
  end

  scenario 'non-admin user' do
    login_as_user
    visit edit_exercise_path(exercises(:pushups))
    expect(page).to have_current_path root_path, ignore_query: true
  end
end

RSpec.describe 'Viewing an exercise', type: :feature do
  fixtures :users, :exercises, :workout_posts, :exercise_posts

  scenario 'through /exercises' do
    login_as_admin
    visit exercises_path
    expect(page).to have_content exercises(:pushups).title
  end

  scenario 'non-admin through /exercises' do
    login_as_user
    visit exercises_path
    expect(page).to have_current_path root_path, ignore_query: true
  end

  scenario 'through /exercises/:id' do
    login_as_admin
    visit exercise_path(exercises(:pushups))
    expect(page).to have_content exercises(:pushups).title
  end

  scenario 'non-admin through /exercises/:id' do
    login_as_user
    visit exercise_path(exercises(:pushups))
    expect(page).to have_current_path root_path, ignore_query: true
  end

  scenario 'non-admin through /submissions/new/:workout_post_id' do
    login_as_user
    visit "/submissions/new/#{workout_posts(:wp1).id}"
    expect(page).to have_content exercises(:pushups).title
  end
end
