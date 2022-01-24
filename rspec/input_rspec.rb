
require "rspec"
require 'curses'
require_relative "../fly"
RSpec.describe Fly do 
  it 'input screen'  do 
    #Curses.init_screen
    #win = Curses::Window.new(Curses.lines,Curses.cols,0,0)
    #win.box("|","-","+")
    screen  = Fly::Screen.new
    screen.render
    #win.getch
  end
end
