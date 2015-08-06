require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base

  enable :sessions

  DEFAULT_PLAYER_NAME = "Anonymous"

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/newgame' do

    @new_game_clicked = true
    $game = Game.new(Player, Board)
    erb :index
  end

  post '/game' do
    @player_name = session[:player_name] if session[:player_name]
    @player_name = set_player_name params if params[:name]
    session[:player_name] = @player_name
    place_ship params if params[:fleet]
    @board = $game.own_board_view($game.player_1)
    erb :game
  end

  post '/play-mode' do
    @player_name = session[:player_name]
    session[:player_name] = @player_name
    @own_board = $game.own_board_view($game.player_1)
    erb :play
  end

  def set_player_name params
    params[:name].empty? ? player_name = DEFAULT_PLAYER_NAME : player_name = params[:name]
  end

  def place_ship params
    ship = params[:fleet]
    coordinate = params[:coordinate].to_sym
    direction = params[:direction].to_sym
    $game.player_1.place_ship(Ship.new(ship.to_sym), coordinate, direction)
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
