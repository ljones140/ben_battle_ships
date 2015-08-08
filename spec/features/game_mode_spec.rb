feature "I am in play mode" do

  before do
    $game = Game.new(Player, Board)
    $player_count = 1
    set_up_player
  end

  def set_up_player
    visit "/newgame"
    fill_in("name", with: "John")
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    page.find(:css, '[name=direction][value=horizontally]').set(true)
    click_button "Submit"
    click_button "ready"
  end

  scenario "I can see my name" do
    expect(page).to have_content "player_1 John"
  end

  scenario "I can go into playing screen" do
      expect(page).to have_content "My Board"
  end

  scenario "I can go into playing screen" do
    expect(page).to have_content "Enemy Board"
  end

  scenario "I can fire on enemy board" do
    fill_in "coordinate", with: "A4"
    click_button "fire"
    expect(page).to have_content "Enemy Board miss ABCDEFGHIJ ------------ 1| |1 2| |2 3| |3 4|- |4 5| |5 6| |6 7| |7 8| |8 9| |9 10| |10 ------------ ABCDEFGHIJ"
  end
end

feature 'hit is returned' do


  before do
    $game = Game.new(Player, Board)
    $player_count = 1
  end

  scenario 'Hit' do
    in_browser(:chrome) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jack")
      click_button 'Submit'
      select "destroyer", from: "fleet"
      fill_in "coordinate", with: "A1"
      page.find(:css, '[name=direction][value=horizontally]').set(true)
      click_button "Submit"
    end


    in_browser(:safari) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jill")
      click_button 'Submit'
      click_button "ready"
      fill_in "coordinate", with: "A1"
      click_button "fire"
      expect(page).to have_content "hit"
    end
  end
end

feature 'A player can sink a ship' do


  before do
    $game = Game.new(Player, Board)
    $player_count = 1
  end

  scenario 'Win' do
    in_browser(:chrome) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jack")
      click_button 'Submit'
      select "submarine", from: "fleet"
      fill_in "coordinate", with: "A1"
      click_button "Submit"
      select "submarine", from: "fleet"
      fill_in "coordinate", with: "B1"
      click_button "Submit"
    end


    in_browser(:safari) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jill")
      click_button 'Submit'
      click_button "ready"
      fill_in "coordinate", with: "A1"
      click_button "fire"
      expect(page).to have_content "sunk"
    end
  end
end

feature 'A player can win' do


  before do
    $game = Game.new(Player, Board)
    $player_count = 1
  end

  scenario 'Win' do
    in_browser(:chrome) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jack")
      click_button 'Submit'
      select "submarine", from: "fleet"
      fill_in "coordinate", with: "A1"
      page.find(:css, '[name=direction][value=horizontally]').set(true)
      click_button "Submit"
    end

    in_browser(:safari) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jill")
      click_button 'Submit'
      click_button "ready"
      fill_in "coordinate", with: "A1"
      click_button "fire"
      expect(page).to have_content "You Have won"
    end
  end
end

feature 'A player can lose' do

  before do
    $game = Game.new(Player, Board)
    $player_count = 1
  end

  scenario 'lose' do
    in_browser(:chrome) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jack")
      click_button 'Submit'
      select "submarine", from: "fleet"
      fill_in "coordinate", with: "A1"
      page.find(:css, '[name=direction][value=horizontally]').set(true)
      click_button "Submit"
    end

    in_browser(:safari) do
      visit '/'
      click_button "New Game"
      fill_in("name", with: "Jill")
      click_button 'Submit'
      click_button "ready"
      fill_in "coordinate", with: "A1"
      click_button "fire"
    end

    in_browser(:chrome) do
      click_button "ready"
      expect(page).to have_content "You Have lost"
    end
  end
end

def in_browser(name)
  old_session = Capybara.session_name
  Capybara.session_name = name
  yield
  Capybara.session_name = old_session
end


