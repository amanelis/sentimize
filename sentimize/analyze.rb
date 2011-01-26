require 'rubygems'
require 'sentimize/words'
require 'open-uri'
require 'formatador'

module Sentimize
  class Analyze
    
    # Make usuable variables accessible via
    # entire instance of class
    attr_accessor :time, :positive, :negative
    
    def initialize(options ={})
      @time = Time.now
      @dict = Sentimize::Words.new
      
      @positive = @dict.open_dictionary(@dict.pos1)
      @negative = @dict.open_dictionary(@dict.neg1)
      @formatador = Formatador.new
    end
    
    def sentimate(input)
      ti = input
      character_count = ti.length
      character_count_nospace = ti.gsub(/\s+/, '').length
      word_count = ti.split.length
      tokens = ti.split.collect{|a| a.downcase.strip }
      
      it_is_negative = 0
      it_is_positive = 0
     
      @positive.each do |p|
        tokens.each do |token|         
          if token.to_s == p.to_s
            it_is_positive = (it_is_positive + 1)
          end
        end
      end
    
      @negative.each do |n|
        tokens.each do |token|
          if token.to_s == n.to_s
            it_is_negative = (it_is_negative + 1)
          end
        end
      end
      
      puts "Checking sentiment..."
      if it_is_positive == 0 && it_is_negative == 0
        puts "Sentiment: Neutral\nTweet: " + input 
      else
        if it_is_positive == it_is_negative
          puts "Sentiment: P&N\nTweet: " + input
        elsif it_is_positive > it_is_negative
          puts "Sentiment: Positive\nTweet: " + input
        elsif if_is_negative > it_is_positive
          puts "Sentiment: Negative\nTweet: " + input
        else
          puts "Sentiment: Could not be determined..."
        end
      end
      puts "Positives: #{it_is_positive}, Negatives: #{it_is_negative}"


      puts "\n\n"
      $stdout.flush
    end

  end
end
