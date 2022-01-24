#module Fly 
#  class Screen 
#    class Input 
#      include Curses
#      def initialize 
#        @win = stdscr.subwin(4,stdscr.maxx,stdscr.maxy - 4,0)
#      end
#      def render
#        input = Field.new(2,@width - 15 ,1,10,1,0)
#        input.opts_off(Curses::O_AUTOSKIP)
#        @form = Form.new([input])
#        @form.set_win(@win)
#        @form.post
#        @win.setpos(stdscr.maxy - 4 , 1)
#        @win.addstr("Search: ")
#        @win.setpos(stdscr.maxy - 4 , 15)
#        @win.box("|","-","+")
#        # @window.addstr("Hello input")
#        # Thread.new do 
#        #   keyword = []
#        #   loop do 
#        #     ch = @window.getstr
#        #     # fn = key_maps.fetch(ch){ proc {|c|
#        #     #   @window.setpos(@height - 2,@window.curx)
#        #     #   @window.addstr(c)
#        #     #   keyword << c.to_s
#        #     #   @window.refresh
#        #     # } } 
#        #     fn.call(ch)
#        #   end
#        # end
#      end
#    end
#    include Curses
#    include Fly::View
#    def initialize
#      @screen = init_screen
#      noecho 
#      raw 
#      curs_set(0)
#      stdscr.keypad(true)
#      start_color
#      use_default_colors
#    end
#    def wait
#      t = Thread.new do 
#        loop{ 
#          key = getch
#        }
#      end
#    end
#    def key_mapper
#    end
#  end
#end
