require "./openweather"
require "option_parser"

module WeatherBar
  VERSION = "0.1.0"

  weather_api_call = false
  onecall_api_call = false
  
  city : String = ""
  country_code : String = ""
  latitude : String =  ""
  longitude : String =  ""

  openweather_api_key : String = ENV["API_KEY"] ||= ""

  OptionParser.parse do |parser|
    parser.banner = "Usage: weather_bar [weather|onecall] [arguments]"
    parser.on("weather", "Return results from the 'weather' API call") do
      weather_api_call = true
      parser.on("-c CITY", "--city CITY", "Specify the city to get weather for") {|city_input| city = city_input }
      parser.on("-C COUNTRY_CODE", "--country COUNTRY_CODE", "Specify the country code to get weather for") {|country_code_input| country_code = country_code_input}
    end

    parser.on("onecall", "Return results from the 'onecall' API call") do
      onecall_api_call = true
      parser.on("-l LAT", "--latitude LAT", "Latitude to get weather for, in decimal notation") { |latitude_input| latitude = latitude_input }
      parser.on("-L LON", "--longitude LON", "Longitude to get weather for, in decimal notation") { |longitude_input| longitude = longitude_input }
    end
    
    parser.on("-a API_KEY", "--api-key API_KEY", "Pass your openweather API key using this option or the API_KEY env variable") { |api_key| openweather_api_key = api_key }
    parser.on("-v", "--version", "Show current version.") do
      puts "weather_bar version #{VERSION}"
      exit
    end
    
    parser.invalid_option do |flag|
      STDERR.puts "\e[31mError:\e[0m #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end 
  
  if openweather_api_key == ""
    STDERR.puts "No OpenWeather API key specified"
    exit(0)
  end
 
  unless weather_api_call || onecall_api_call
    STDERR.puts "At least one API call must be requested"
    exit(1)
  end

  openweather_api = OpenWeather.new(openweather_api_key) 
 
  returned_str = openweather_api.weather(city, country_code) if weather_api_call
  returned_str = openweather_api.onecall(latitude, longitude) if onecall_api_call
  puts returned_str
end
