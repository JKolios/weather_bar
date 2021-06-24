require "http/client"
require "json"
require "./openweather_exception"

class OpenWeather

  API_BASE_URL = "api.openweathermap.org/data/2.5"
  DEFAULT_UNITS = "metric"

  def initialize(api_key : String, units : String = DEFAULT_UNITS)
    @api_key = api_key
    @units = units
  end

  def weather(city : String, country_code : String) : String
    api_response = weather_api_call({"city" => city, "country_code" => country_code})
    parsed_response = JSON.parse(api_response.body) 
    "#{parsed_response["weather"][0]["main"].to_s} #{parsed_response["main"]["temp"].to_s} #{temperature_unit}"
  end

  def onecall(latitude : String, longitude : String) : String
    api_response = onecall_api_call({"latitude" => latitude, "longitude" => longitude})
    parsed_response = JSON.parse(api_response.body) 
    "#{parsed_response["current"]["weather"][0]["main"].to_s}  #{parsed_response["current"]["temp"].to_s} #{temperature_unit}"
  end

  private def weather_api_call(method_params : Hash(String, String)) : HTTP::Client::Response
    api_call("weather", weather_method_param_string(method_params))
  end
  
  private def onecall_api_call(method_params : Hash(String, String)) : HTTP::Client::Response
    api_call("onecall", onecall_method_param_string(method_params))
  end

  private def api_call(method : String, method_param_string : String) : HTTP::Client::Response
    response = HTTP::Client.get api_call_url(method, method_param_string)
    raise OpenWeatherException.new("API Call Error") unless response.success? && response.body?
    response
  end

  private def weather_method_param_string(method_params : Hash( String, String)) : String
    "q=#{method_params["city"]},#{method_params["country_code"]}"
  end
  
  private def onecall_method_param_string(method_params : Hash( String, String)) : String
    "lat=#{method_params["latitude"]}&lon=#{method_params["longitude"]}"
  end
  
  private def api_call_url(method : String, method_param_string : String) : String
    "#{API_BASE_URL}/#{method}?#{method_param_string}&appid=#{@api_key}&units=#{@units}"
  end

  private def temperature_unit() : String
    {"standard" => "K", "metric" => "C", "imperial" => "F"}[@units]
  end
end
