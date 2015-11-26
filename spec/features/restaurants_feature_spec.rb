require 'rails_helper'

feature 'restaurants:' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'Nandos')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Nandos')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts users to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Nandos'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Nandos'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it ' does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end

      it 'is not valid unless is has a unique name' do
        Restaurant.create(name: "AMY AND MATEJAS PLACE")
        restaurant = Restaurant.new(name: "AMY AND MATEJAS PLACE")
        expect(restaurant).to have(1).error_on(:name)
      end
    end

  end

  context 'viewing restaurants' do

  let!(:nandos){Restaurant.create(name:'Nandos')}

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'Nandos'
     expect(page).to have_content 'Nandos'
     expect(current_path).to eq "/restaurants/#{nandos.id}"
    end
  end

  context 'editing restaurants' do

    before { Restaurant.create name: 'Nandos' }

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit Nandos'
      fill_in 'Name', with: 'Nandos Restaurant'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Nandos Restaurant'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do

    before { Restaurant.create name: 'Nandos' }

    scenario 'removes a restaurant when a user clicks delete link' do
      visit '/restaurants'
      click_link 'Delete Nandos'
      expect(page).not_to have_content 'Nandos'
      expect(page).to have_content 'Restaurant deleted succesfully'
    end
  end
end
