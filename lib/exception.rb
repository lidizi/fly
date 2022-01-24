
module Fly
  module Try 
    class FlyError < StandardError;end
    def try(msg)
      begin 
        yield
      rescue FlyError,msg
      end
    end
  end
end
