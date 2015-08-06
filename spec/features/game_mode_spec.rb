feature "I am in play mode" do

  before do
    $game = Game.new(Player, Board)
    set_up_player
  end

  def set_up_player
    visit "/newgame"
    click_button "Submit"
    select "destroyer", from: "fleet"
    fill_in "coordinate", with: "A1"
    page.find(:css, '[name=direction][value=horizontally]').set(true)
    click_button "Submit"
    click_button "ready"
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
    expect(page).to have_content "Enemy Board ABCDEFGHIJ ------------ 1| |1 2| |2 3| |3 4|- |4 5| |5 6| |6 7| |7 8| |8 9| |9 10| |10 ------------ ABCDEFGHIJ"

  end


end