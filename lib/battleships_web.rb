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
    @player_to_play = set_player_to_play
    erb :index
  end

  post '/game' do
    @player_name = session[:player_name] if session[:player_name]
    @player_name = set_player_name params if params[:name]
    session[:player_name] = @player_name
    @player_to_play = session[:player_to_play]
    session[:player_to_play] = @player_to_play
    place_ship params if params[:fleet]
    @board = $game.own_board_view($game.send(@player_to_play))
    erb :game
  end

  post '/play-mode' do
    @player_name = session[:player_name]
    @player_to_play = session[:player_to_play]
    session[:player_name] = @player_name
    @own_board = $game.own_board_view($game.send(@player_to_play))
    shoot params if params[:fire]
    @enemy_board = $game.opponent_board_view($game.send(@player_to_play))
    erb :play
  end

  def set_player_to_play
    player_to_play = "player_1" unless session[:player_to_play].freeze
    player_to_play = "player_2" if session[:player_to_play] == "player_1"
    player_to_play = "player_1" if session[:player_to_play] == "player_2"
    session[:player_to_play] = player_to_play
    player_to_play
  end

  # def set_player_to_play
  #     player_to_play = session[:player_to_play].freeze
  #   if player_to_play == "player_1"
  #     session[:player_to_play] = "player_2"
  #   elsif player_to_play == "player_2"
  #     session[:player_to_play] = "player_1 "
  #   else
  #     session[:player_to_play] = "player_1"
  #   end
  # end

  def shoot params
    @player_to_play = session[:player_to_play]
    coordinate = params[:coordinate].to_sym
    if session[:player_to_play] == "player_1"
      $game.player_1.shoot coordinate
    else
      $game.player_2.shoot coordinate
    end
  end

  def set_player_name params
    params[:name].empty? ? player_name = DEFAULT_PLAYER_NAME : player_name = params[:name]
  end

  def place_ship params
    @player_to_play = session[:player_to_play]
    ship = params[:fleet]
    coordinate = params[:coordinate].to_sym
    direction = params[:direction].to_sym
    if session[:player_to_play] == "player_1"
      $game.player_1.place_ship(Ship.new(ship.to_sym), coordinate, direction)
    else
      $game.player_2.place_ship(Ship.new(ship.to_sym), coordinate, direction)
    end
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
