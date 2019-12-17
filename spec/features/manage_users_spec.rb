# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Manage users', type: :feature do
  before do
    create(:user_management_admin, email: 'test@test.com')
  end

  it 'Allows to manage users' do
    visit '/'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123'
    click_button 'Sign In'

    click_link('Users')
    click_link('New admin')

    fill_in 'Email', with: 'admin@test.com'
    click_button 'Save'

    expect(page).to have_content 'Password invalid'

    fill_in 'Password', with: 'qwerty'
    click_button 'Save'

    expect(page).to have_content 'admin@test.com'
    # Find link with max id
    page.all('a', text: 'Edit').max_by { |el| el['href'] }.click

    fill_in 'Email', with: 'new_admin@test.com'
    fill_in 'Password', with: 'qwerty'
    click_button 'Save'

    expect(page).to have_content 'new_admin@test.com'

    visit '/'
    fill_in 'Email', with: 'new_admin@test.com'
    fill_in 'Password', with: 'qwerty'
    click_button 'Sign In'

    expect(page).to have_current_path('/admin_space')
  end
end
