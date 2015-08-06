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
    expect(page).to have_selector("input[type=radio][name='direction']")
  end

  scenario "I can place a ship" do
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    page.find(:css, '[name=direction][value=horizontally]').set(true)
    click_button "Submit"
    expect(page).to have_content
    "ABCDEFGHIJ
  ------------
 1|DD        |1
 2|          |2
 3|          |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ"
 end


  scenario "I can place multiple ship" do
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    page.find(:css, '[name=direction][value=horizontally]').set(true)
    click_button "Submit"
    select "cruiser", from: "fleet"
    fill_in "coordinate", with: "B4"
    page.find(:css, '[name=direction][value=vertically]').set(true)
    click_button "Submit"
    expect(page).to have_content
    "ABCDEFGHIJ
  ------------
 1|DD        |1
 2|          |2
 3|          |3
 4| C        |4
 5| C        |5
 6| C        |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ"
  end
end

