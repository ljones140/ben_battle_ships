require "spec_helper"

feature "Starting a new game" do
  scenario "I am asked to enter my name" do
    visit "/"
    click_button "New Game"
    expect(page).to have_content "Enter name"
  end
end

