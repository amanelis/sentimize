require 'rubygems'
require 'json'
require 'yajl'
require 'formatador'
require 'yajl/json_gem'
require 'twitter/json_stream'
require 'sentimize/analyze'
require 'sentimize/words'

module Sentimize
  # Sentimize module starts with a client class that the user uses to set
  # the default twitter username/password. From this point it starts by 
  # calling the event machine to pull twitter stream based on your intialized
  # term the event machine will pass to twitter API. From inside this call
  # the SENTIMATE function will be run to determine the mood of the current
  # twitter stream.post is.

  class Client
    # Allow return of user pass, for testing
    attr_accessor :user, :pass, :auth, :term, :meth
  
    # Class.new
    # Setting up initail instance oj object, values of POST should not be 
    # changed unless setting up a different query to twitter. Term can
    # accept more than one search term, can pass in an array of values,
    # just be sure to split them and put in a comma
    def initialize(username, password, term)
      @user = username
      @pass = password
      @auth = "#{user}:#{pass}"
      @term = "track=#{term}"
      @meth = "POST"
    end
    
    # Class.start(sentence)
    # Start running instance. This will start the even machine to start
    # querying twitter for any search term specified. Output is in JSON
    # so must be handled properly. Once output is contained will make a 
    # call to the sentimate function which will try to sentimate twitter
    # stream into positive/negative
    def start
      s = Sentimize::Analyze.new
      e = EventMachine::run {
        stream = Twitter::JSONStream.connect(
            :path    => '/1/statuses/filter.json',
            :auth    => auth,
            :method  => meth,
            :content => term
        )
        stream.each_item do |item|
          element = JSON.parse(item)
          text = element['text']
          
          # Make the call to sentimate to start passing twitter feeds
          # into function to be sentimized
          s.sentimate(text)
          $stdout.flush
        end
      }
    end
    

  end
end


client = Sentimize::Client.new('username', 'password', 'tea').start






