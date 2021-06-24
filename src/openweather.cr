require "http/client"
require "json"
require "./openweather_exception"

class OpenWeather

  API_BASE_URL = "api.openweathermap.org/data/2.5"
  UNITS = "metric"

  def initialize(api_key : String)
    @api_key = api_key
  end

  def weather(city, country_code)
    api_response = self.api_call("weather", {"city" => city, "country_code" => country_code})
    parse_api_response("weather", api_response)
  end

  def onecall(latitude, longitude)
    api_response = self.api_call("onecall", {"latitude" => latitude, "longitude" => longitude})
    parse_api_response("onecall", api_response)
  end

  private def api_call(method : String, method_params : Hash(String, String))
    response = HTTP::Client.get api_call_url(method, construct_method_param_string(method, method_params))
    raise OpenWeatherException.new("API Call Error") unless response.success? && response.body?
    response.body
  end

  private def construct_method_param_string(method : String, method_params : Hash( String, String))
    case method
    when "weather"
      "q=#{method_params["city"]},#{method_params["country_code"]}"
    when "onecall"
      "lat=#{method_params["latitude"]}&lon=#{method_params["longitude"]}"
    else
      ""
    end
  end

  private def api_call_url(method : String, method_param_string : String)
    "#{API_BASE_URL}/#{method}?#{method_param_string}&appid=#{@api_key}&units=#{UNITS}"
  end

  private def parse_api_response(method : String, api_response) 
    parsed_response = JSON.parse(api_response)
    case method
    when "weather"
      parsed_response["weather"][0]["main"]  
    when "onecall"
      parsed_response["current"]["weather"][0]["main"]
    end 
  end
end
