require "spec_helper"

feature "Starting a new game" do
  scenario "I am asked to enter my name" do
    visit "/"
    click_button "New Game"
    expect(page).to have_content "Enter name"
  end

  scenario " I enter my name and game starts" do
    visit "/newgame"
    fill_in("name", with: "John")
    click_button "Submit"
    expect(page).to have_content "Player 1: John"
  end

  scenario " I do not enter my name and game starts" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_content "Player 1: Anonymous"
  end

  scenario " I see my board after game starts" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_content "your board"
  end

  scenario "I can see ships when game starts" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_select("fleet", selected: "destroyer")
  end

  scenario "I can enter coordinate" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_selector("input[type=text][name='coordinate']")
  end

  scenario "I can enter polarity" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_selector("input[type=text][name='direction']")
  end

  scenario "I can place a ship" do
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "direction", with: "A1"
    click_button "Submit"
    expect(page).to have content "Ship Placed at A1"
  end
end

