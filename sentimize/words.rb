require 'open-uri'
require 'pp'

module Sentimize
  class Words
    
    # Setup variables to be accessed throughout the life
    # of class instance
    attr_accessor :pos1, :neg1
    
    def initialize(options={})
      @pos1 = '/Users/amanelis/Development/Ror/tmp/lib/sentimize/diction/adj_pos.txt'
      @neg1 = '/Users/amanelis/Development/Ror/tmp/lib/sentimize/diction/adj_neg.txt'
    end
    
    def open_dictionary(url)
      contents = File.open(url, 'rb').read.split.collect{|a| a.downcase.strip }
      return contents
    end
    
  end
end