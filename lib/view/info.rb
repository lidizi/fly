module Fly 
  module View
    class InfoWindow
      include Curses
      def initialize 
        @height,@width = stdscr.maxy - 4 ,stdscr.maxx / 2 + 1
        @win = stdscr.subwin(@height,@width,0,stdscr.maxx / 2 - 1  )
      end
      def render(str)
        @win.clear
        maxx = @win.maxx - 5 
        begin
        # Fly::Log.info(self,"lines => #{str.lines}")
        index = 1
        str.lines.each do | line | 
          if line.size > maxx
            count = line.size / maxx
            count.times.each do | i | 
              @win.setpos(index,5)
              offset = i * maxx
              @win.addstr(line[offset..(offset + maxx)])
              index += 1
            end
            else 
            # (line.size / maxx).times.each do | i | 
            #   s = line[(i * maxx)..(i * maxx + maxx)]
            #   @win.addstr(s)
            # end
            @win.setpos(index,5)
            @win.addstr(line)
            index += 1
          end
        end
        rescue StandardError => e
        Fly::Log.error(self,"e => #{e}")
        ensure
        end
        @win.box("|","-","+")
        @win.refresh
      end
    end
  end
end
