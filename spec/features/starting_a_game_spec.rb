require "spec_helper"

feature "Starting a new game" do
  scenario "I am asked to enter my name" do
    visit "/"
    click_button "New Game"
    expect(page).to have_content "Enter name"
  end

  scenario " I do not enter my name and game starts" do
    visit "/newgame"
    fill_in("name", with: "John")
    click_button "Submit"
    expect(page).to have_content "Player 1: John"
  end

end

