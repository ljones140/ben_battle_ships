require "spec_helper"

feature 'Registering two players' do
  scenario 'I want to register two players' do
    visit '/'
    click_button "New Game"
    fill_in("name", with: "John")
    click_button 'Submit'
    expect(page).to have_content "player_1: John"

    # old_session = Capybara.session_name
    # Capybara.session_name = :second_session

    visit '/'
    click_button "New Game"
    fill_in("name", with: "Jill")
    click_button 'Submit'
    expect(page).to have_content "player_2: Jill"
    # Capybara.session_name = old_session
  end
end


feature "Starting a new game" do

  before { $game = Game.new(Player, Board) }

  scenario "I am asked to enter my name" do
    visit "/"
    click_button "New Game"
    expect(page).to have_content "Enter name"
  end

  scenario " I enter my name and game starts" do
    visit "/newgame"
    fill_in("name", with: "John")
    click_button "Submit"
    expect(page).to have_content "player_1: John"
  end


  scenario " I do not enter my name and game starts" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_content "player_1: Anonymous"
  end

  scenario " I see my board after" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_content "your board"
  end

  scenario "I can see ships" do
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
    expect(page).to have_content "ABCDEFGHIJ
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

  scenario "I can place a ship horizontally by default" do
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    click_button "Submit"
    expect(page).to have_content "ABCDEFGHIJ
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

 scenario "I can place a ship vertically" do
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    page.find(:css, '[name=direction][value=vertically]').set(true)
    click_button "Submit"
    expect(page).to have_content "ABCDEFGHIJ
  ------------
 1|D         |1
 2|D         |2
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
    expect(page).to have_content "ABCDEFGHIJ
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

  scenario "I can ready a game" do
    visit "/newgame"
    click_button "Submit"
    expect(page).to have_selector("input[type=submit][name='ready']")
  end
end



