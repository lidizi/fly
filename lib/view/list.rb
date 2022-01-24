module Fly 
  module View 
    class ListWindow
      include Curses
      def initialize
        # 3 是Input 的高度
        @height,@width = stdscr.maxy - 4 ,stdscr.maxx / 2
        @win = stdscr.subwin(@height,@width,0,0)
        @list = []
        @index = 1
        @info_win = InfoWindow.new
        @app = Fly.context
        # @app = app
      end
      def draw_box 
      end
      def select(list) 
        Curses.timeout = 300
        # Fly::Log.info(self," data => #{list}")
        render(list)
        @win.setpos(1,1)
        loop do 
          ch = getch 
          @index = @win.cury
          begin
          case ch 
          when 9 # Tab 

          when ?c
            begin
            @app.system.copy(@app.torrent list[@index - 1])
            rescue StandardError => e
            Fly::Log.error(self," e => #{e}")
            end
          when ?p 
            @app.player @app.torrent list[@index - 1]
          when Curses::KEY_ENTER
            @app.system.copy(@app.torrent list[@index - 1])
            break unless list
          when ?j
            @index = if @win.cury >= list.size
              1
              else 
              @win.cury + 1 
            end
          when ?k
            @index = if @win.cury <= 1
              list.size
              else 
              @win.cury - 1 
            end
          when Curses::KEY_CTRL_C,?/
            break
            else
          end
          rescue StandardError => e

          end
          render(list)
        end
        @index
      end
      def render(list)
        @win.clear
        list.each_with_index do | item,i |
          @win.setpos(i + 1,1)
          color = 'green' if i == @index - 1
          with_color color do 
            # @win.addstr "  #{i+1}. [#{item[:site]}]#{item[:title][0..30] + "..."}".ljust(@win.maxx - 4)
            @win.addstr "  #{i+1}. [#{item.site}]#{item.title[0..30] + "..."}".ljust(@win.maxx - 4)
          end
        end
        @info_win.render list[@index - 1].render if (0..list.size).to_a.include?(@index)
        @win.box("|","-","+")
        @win.setpos(@index,0)
        @win.refresh
      end
      def with_color(color = nil)
        colors = { 
          green: Curses::COLOR_GREEN
        }
        Curses.init_pair(1, 100, 0)
        unless color.nil?
        @win.attron(Curses.color_pair(1))
        yield
        @win.attroff(Curses.color_pair(1))
        else
        yield
        end
      end
    end
  end
end
