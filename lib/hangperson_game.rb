class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @temp = word
  end

  def guess(letter)
    validate_input!(letter)

    if has_letter?(@word, letter)

      prev = @guesses
      @guesses = add_guess(@guesses, letter)

      prev != @guesses
    else
      prev = @wrong_guesses
      @wrong_guesses = add_guess(@wrong_guesses, letter)

      prev != @wrong_guesses
    end
  end

  def word_with_guesses
    @word.chars.map do |char|
      @guesses.include?(char) ? char : '-'
    end.join 
  end

  def check_win_or_lose
    return :win if @word.delete(@guesses).empty?

    return :lose if @wrong_guesses.length >= 7

    :play
  end

  private

  def add_guess(answers , letter)
    has_letter?(answers, letter) ? answers : answers + letter
  end

  def has_letter?(str, letter)
    str.match?(/#{letter}/i)
  end

  def validate_input!(letter)
    raise ArgumentError unless letter && letter.match?(/\w/)
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
