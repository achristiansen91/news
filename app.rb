require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "e07aae4e0da3ef1331609107e4491153"

#News API key with "&pageSize=5" in order to just give the top 5 news
url = "https://newsapi.org/v2/top-headlines?country=us&pageSize=5&apiKey=e78de3e85b544bbbb7895758899191a8"

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
  # Weather:
    @location = params["location"]
    results = Geocoder.search(params["location"])
    lat_lng = results.first.coordinates
    @lat = lat_lng[0]
    @lng = lat_lng[1]
    @forecast = ForecastIO.forecast(@lat,@lng).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_conditions = @forecast["currently"]["summary"]
    @daily_forecast = @forecast["daily"]["data"]
    

    #News:
    @news = HTTParty.get(url).parsed_response.to_hash
    @headlines = @news["articles"]

  view "news"
end