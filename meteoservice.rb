# Подключаем нужные библиотеки
require 'net/http'
require 'rexml/document'

# Подключаем класс MeteoserviceForecast
require_relative 'lib/meteoservice_forecast'

city = 0

puts "Погоду для какого города Вы хотите узнать?"
puts "
1: Москва
2: Санкт-Петербург
3: Новосибирск
4: Белгород
5: Чита
6: Братск
7: Краснодар" 

#URL = 'https://www.meteoservice.ru/export/gismeteo/point/112.xml'.freeze

user_choice = STDIN.gets.chomp.to_i
if user_choice != '' && user_choice != nil
  city = MeteoserviceForecast::CITIES[user_choice - 1]
end
indx = user_choice.to_i

str = MeteoserviceForecast::Urla[indx -1]

URL = "https://www.meteoservice.ru/export/gismeteo/point/#{MeteoserviceForecast::Urla[user_choice]}.xml"


response = Net::HTTP.get_response(URI.parse(URL))
doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])

# Достаем все XML-теги <FORECAST> внутри тега <TOWN> и преобразуем их в массив
forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a


puts city 

forecast_nodes.each do |node|
  puts MeteoserviceForecast.from_xml(node)
  puts
end