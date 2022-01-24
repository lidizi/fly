require 'curses'


include Curses
Curses.init_screen

index = 0
loop do 
  index += 1
  setpos(index,2)
  ch = getch
  addstr(ch.to_s)
end


