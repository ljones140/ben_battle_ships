require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base

  use Rack::Session::Cookie,:key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'

  DEFAULT_PLAYER_NAME = "Anonymous"

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/newgame' do

    @new_game_clicked = true
    erb :index
  end

  post '/game' do
    player_name = session[:player_name] if session[:player_name]
    if params[:name]
      params[:name].empty? ? player_name = DEFAULT_PLAYER_NAME : player_name = params[:name]
    end
    session[:player_name] = player_name
    @name_display = "Player 1: #{player_name}" if player_name
    $game = Game.new(Player, Board)
    if params[:fleet]
      ship = params[:fleet]
      coordinate = params[:coordinate].to_sym
      direction = params[:direction].to_sym
      $game.player_1.place_ship(Ship.new(ship.to_sym), coordinate, direction)
      @ship_placed = true
    end
    @board = $game.own_board_view($game.player_1)
    erb :game
  end

  # get '/game' do
  #   player_name = session[:player_name]
  #   @name_display = "Player 1: #{player_name}" if session[:player_name].length > 0
  #   ship = params[:fleet]
  #   coordinate = params[:coordinate]
  #   position = params[:position]
  #   $game.player_1.place_ship(Ship.battleship, :B4, :vertically)
  #   @board = $game.own_board_view($game.player_1)
  #   erb :game
  # end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
