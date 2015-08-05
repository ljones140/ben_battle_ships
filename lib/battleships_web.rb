require 'sinatra/base'

class BattleshipsWeb < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/newgame' do

    @new_game_clicked = true

    erb :index
  end

  post '/game' do
    player_name = params[:name]
    p player_name
    session[:player_name] = player_name
    @name_display = "<h2 name=\"playername\">Player 1: #{player_name}</h2>" if player_name.length > 0
    erb :game
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
