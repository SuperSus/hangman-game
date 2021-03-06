require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess].to_s[0]
    
    begin
      flash[:message] = 'You have already used that letter.' unless @game.guess(letter)
    rescue ArgumentError => e
      flash[:message] = 'Invalid guess'   
    end

    case @game.check_win_or_lose
    when :win then redirect '/win'
    when :lose then redirect '/lose' end

    redirect '/show'
  end

  get '/show' do
    erb :show 
  end
  
  get '/win' do
    redirect '/new' unless :win == @game.check_win_or_lose
    
    erb :win 
  end
  
  get '/lose' do
    erb :lose 
  end
end
