require 'curses'

module Fly 
  class Screen 
    include Fly::View
    include Curses
    attr_accessor :data,:app,:search_win,:result_win,:screen
    def initialize
      Fly::Log.info(self,"initialize #{app}")
      @screen = init_screen
      noecho
      raw
      curs_set(0)
      stdscr.keypad(true)
      start_color
      use_default_colors
      @app = Fly.context
      @input_win = InputWindow.new
      @list_win = ListWindow.new
      Fly::Log.info(self,"initialize successed")
    end
    def render 
      Fly::Log.info(self,"screen render...")
      wait
    end
    def search(kw)
      Fly::Log.info(self,"search #{kw}")
      @data = @app.search(kw) || DATE
    end
    def wait 
      Curses.timeout = 10
      t = Thread.new do 
        loop{ 
          ch = getch 
          case ch
          when '/' # /
            kw = @input_win.input
            search(kw)
            @list_win.select(@data)
          when Curses::KEY_CTRL_P
            @list_win.select(@data)
          when Curses::KEY_CTRL_N
            @list_win.render(@data)
          when Curses::KEY_CTRL_C
            break
            else
          end
        }
      end
      t.join
    end
  end
end
