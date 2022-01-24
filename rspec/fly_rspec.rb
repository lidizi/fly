require "rspec"
require_relative "../fly"
RSpec.describe Fly do 
  it 'fly 下载',skip: true do 
#    fly = Fly::Application.new
#    fly.search("ipx")
  end
  it '1377x' do 
    Fly.run
  end
end
