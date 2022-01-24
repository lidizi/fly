module Fly 
  module View 
    class InputWindow
      include Curses
      class CancelInput < StandardError; end
      def initialize
        @height,@width = 5,stdscr.maxx 
        @top = stdscr.maxy - @height
        @win = stdscr.subwin(@height,@width,@top,0)
      end
      def input 
        @str = ''
        render_current_str
        Curses.timeout = 20
        chars = []
        loop do 
          ch = getch 
          if ch.nil?
            case chars.first
            when 3,27 # cancel with <C-c>
              raise CancelInput
            when 10 
              break
            when Curses::KEY_ENTER 
              if @str 
                break
              end
            when 127 # backspace 
              @str.chop!
              render_current_str
            when 0..31 
              # 忽略 0x00 - 0x1f 
              else 
              next if chars.empty?
              @str << chars.map{|x| x.is_a?(String) ? x.ord : x}.pack("C*").force_encoding("utf-8")
              render_current_str
            end
            chars = []
            else 
            chars << ch
          end
        end
        @str
      end
      def render_current_str
        render(@str)
      end
      def render(str)
        @win.clear
        @win.box("|","-","+")
        @win.setpos(2,5)
        @win.addstr("#{symbol}#{str}")
        @win.refresh
      end
      def symbol 
        "Search > "
      end
    end
  end
end
