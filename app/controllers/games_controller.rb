require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]

    if included?(@word, @letters)
      if english_word?(@word)
        @response = "🥳 Well done! You spotted \"#{@word}\"!"
      else
        @response = "🇬🇧 Sorry but \"#{@word}\" isn't an English word."
      end
    else
      @response = "🔎 Sorry but \"#{@word}\" cannot be built out of #{@letters}."
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
