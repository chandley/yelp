require 'rails_helper'

def sign_in_example_user
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end


feature 'restaurants' do
  context 'no restaurants have been added' do
   before {sign_in_example_user}

    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    scenario 'promps user to fill out a form, the displays the new restaurant' do
      visit '/restaurants'
      sign_in_example_user
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    it 'shows uploaded restaurant image' do
      visit '/restaurants'
      sign_in_example_user
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      attach_file 'Image', File.join(Rails.root, 'spec', 'fixtures', 'files', 'cat.jpg')
      click_button 'Create Restaurant'
      expect(page).to have_css("img[alt='Cat']")
    end


  end

  context 'an invalid restaurant' do
    it 'does not let you submit a name that is too short' do
      visit '/restaurants'
      sign_in_example_user
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end
  
  context 'viewing restaurants' do
    before { @kfc = Restaurant.create(name:'KFC') }

    it 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{@kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do sign_in_example_user 
           Restaurant.create(name:'KFC')
         end

    it 'lets a user edit a restaurant' do

      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end
  end


  describe 'deleting restaurants' do
    before do sign_in_example_user 
           Restaurant.create(name:'KFC')
         end

    it 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end



end