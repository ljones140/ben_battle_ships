require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base

  enable :sessions

  DEFAULT_PLAYER_NAME = "Anonymous"

  set :views, proc { File.join(root, '..', 'views') }
  set :public, proc { File.join(root, '..', 'public') }

  get '/' do
    erb :index
  end

  get '/newgame' do
    @new_game_clicked = true
    $game ? $game : $game = Game.new(Player, Board)
    $player_count ? $player_count = $player_count : $player_count = 1
    @player_to_play = set_player_to_play
    erb :index
  end

  post '/game' do
    @player_name = session[:player_name] if session[:player_name]
    @player_name = set_player_name params if params[:name]
    session[:player_name] = @player_name
    @player_to_play = session[:player_to_play]
    place_ship params if params[:fleet]
    @board = $game.own_board_view($game.send(@player_to_play))
    erb :game
  end

  post '/play-mode' do
    @player_name = session[:player_name]
    @player_to_play = session[:player_to_play]
    @own_board = $game.own_board_view($game.send(@player_to_play))
    @shoot_result = shoot params if params[:fire]
    @enemy_board = $game.opponent_board_view($game.send(@player_to_play))
    @win_status = "You Have won" if is_player_winner?
    @win_status = "You Have lost" if is_player_loser?
    erb :play
  end

  def set_player_to_play
    player_to_play = "player_2" if $player_count > 1
    if $player_count == 1
      player_to_play = "player_1"
      $player_count += 1
    end
    session[:player_to_play] = player_to_play
    player_to_play
  end


  def shoot params
    coordinate = params[:coordinate].to_sym
    if session[:player_to_play] == "player_1"
      result = $game.player_1.shoot coordinate
    else
      result = $game.player_2.shoot coordinate
    end
    result
  end

  def set_player_name params
    params[:name].empty? ? player_name = DEFAULT_PLAYER_NAME : player_name = params[:name]
  end

  def place_ship params
    ship = params[:fleet]
    coordinate = params[:coordinate].to_sym
    direction = params[:direction].to_sym
    if session[:player_to_play] == "player_1"
      $game.player_1.place_ship(Ship.new(ship.to_sym), coordinate, direction)
    else
      $game.player_2.place_ship(Ship.new(ship.to_sym), coordinate, direction)
    end
  end

  def is_player_winner?
    if session[:player_to_play] == "player_1"
      won = $game.player_1.winner?
    else
      won = $game.player_2.winner?
    end
    won
  end

  def is_player_loser?
    if session[:player_to_play] == "player_1"
      lost = true unless $game.player_1.winner?
    else
      lost = true unless $game.player_2.winner?
    end
    lost
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
