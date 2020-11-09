require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle[0,9]
  end

  def score
    word = params[:word]
    letters = params[:letters].split

    if letters_not_included?(letters, word)
      @result = "sorry, but #{word} can't be built out of #{letters}. Your score is #{session[:score]}"
      session.delete(:score)
    elsif exist?(word) == false
      session.delete(:score)
      @result = "sorry, but #{word} does not seem to be a valid english word..Your score is #{session[:score]}"
    else
      if session[:score].nil?
        session[:score] = word.length
      else
        session[:score] += word.length
      end
      @result = "Congratulations! #{word} seems to be a valid english word 😄. Your score is #{session[:score]}"
    end
  end

  private

  def letters_not_included?(letters, word)
    result = word.split("").map do |l|
      letters.include?(l)
    end
    result.include?(false)
  end

  def exist?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word_dictionary = JSON.parse(word_serialized)
    result = word_dictionary['found']
    return result
  end
end
