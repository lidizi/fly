require 'http'
require 'json'

RSpec.describe HTTP do 
  it '测试cookie' do 
    response = HTTP.get('http://clb6.cc/')
    response.headers.each do | k,v|
      puts "#{k} => #{v}"
    end
    puts JSON.pretty_generate(response.headers)
  end
end
