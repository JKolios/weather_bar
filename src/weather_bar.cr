require "./openweather"

module DeezNuts
  VERSION = "0.1.0"
  OPENWEATHER_API_KEY = ENV["API_KEY"] ||= "NO_API_KEY"

  @@openweather_api = OpenWeather.new(OPENWEATHER_API_KEY) 
  
  def self.weather 
    @@openweather_api.weather("Athens", "GR") 
  end

  def self.onecall
    @@openweather_api.onecall("38.020959","24.008401")
  end

  puts "Weather: #{weather}"
  puts "OneCall: #{onecall}"

end
