module Fly 
  class System 
    def exec(command)
      `#{command}`
    end
    def copy(str)
      Fly::Log.info(self,"copy => #{str}")
      case version 
      when ?m 
        `echo "#{str}" | pbcopy`
      when ?l 
        `echo "#{str}" | xclip-selection c`
      else
        `echo "#{str}" | xsel`
      end
    end
    def version
      ?m
    end
  end
end
