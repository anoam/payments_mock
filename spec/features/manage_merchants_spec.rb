# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Manage merchants', type: :feature do
  before do
    create(:user_management_admin, email: 'test@test.com')
  end

  it 'Allows to manage merchants' do
    visit '/'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123'
    click_button 'Sign In'

    click_link('Merchants')
    click_link('New')

    fill_in 'Name', with: 'test merchant'
    click_button 'Save'

    expect(page).to have_content 'Invalid email'

    fill_in 'Email', with: 'merchant@test.com'
    click_button 'Save'

    expect(page).to have_content 'test merchant'
    expect(page).to have_content 'merchant@test.com'
    click_link('Edit')

    fill_in 'Name', with: 'New test name'
    fill_in 'Description', with: 'Very cool description'
    click_button 'Save'

    expect(page).to have_content 'New test name'

    click_link('User')

    expect(page).to have_content 'merchant@test.com'

    # Login as newly created merchant
    visit '/'
    fill_in 'Email', with: 'merchant@test.com'
    fill_in 'Password', with: 'merchant@test.com'
    click_button 'Sign In'

    expect(page).to have_current_path('/merchant_space')
  end
end
