# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a NycGovernmentPublication', js: false do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end
    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)

      # Grant the user access to deposit into the admin set.
      Hyrax::PermissionTemplateAccess.create!(
        permission_template_id: permission_template.id,
        agent_type: 'user',
        agent_id: user.user_key,
        access: 'deposit'
      )
      login_as user
    end

    scenario do
      visit '/dashboard'
      click_link "Works"
      click_link "Add new work"

      # If you generate more than one work uncomment these lines
      # choose "payload_concern", option: "NycGovernmentPublication"
      # click_button "Create work"

      expect(page).to have_content "Add New NYC Government Publication"
      click_link "Files" # switch tab
      expect(page).to have_content "Add files"
      expect(page).to have_content "Add folder"
      within('span#addfiles') do
        attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/image.jp2", visible: false)
        attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/jp2_fits.xml", visible: false)
      end
      click_link "Descriptions" # switch tab
      fill_in('nyc_government_publication_title', with: 'My Test Submission')
      page.select 'Actuary, NYC Office of the', from: 'nyc_government_publication_agency'
      page.select 'Accounting', from: 'nyc_government_publication_subject'
      fill_in('nyc_government_publication_description', with: 'This is some test description. This is some test description. This is some test description. This is some test description. ')
      fill_in('nyc_government_publication_date_issued', with: '01/01/2019')
      page.select 'Adjudications / Decisions', from: 'nyc_government_publication_report_type'
      page.select 'English', from: 'nyc_government_publication_language'
      fill_in('nyc_government_publication_fiscal_year', with: '2019')

      # With selenium and the chrome driver, focus remains on the
      # select box. Click outside the box so the next line can't find
      # its element
      find('body').click
      choose('nyc_government_publication_visibility_restricted')
      expect(page).to have_content('Keep to myself with option to share.')
      check('agreement')

      click_on('Save')
      expect(page).to have_content('My Test Submission')
      expect(page).to have_content 'Your files are being processed by Hyrax in the background.'
    end
  end
end
