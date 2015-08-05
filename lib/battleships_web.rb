require 'sinatra/base'

class BattleshipsWeb < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/newgame' do

    @new_game_clicked = true
    # @to_return = "<h1>What's your name?</h1>
    #               <form action=\"game\" method=\"POST\">
    #                 <input type=\"text\" name=\"playername\">
    #                 <input type=\"submit\" value=\"submit\">
    #               </form>"
    erb :index
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
