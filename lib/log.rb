module Fly 
  module Log 

    class << self 
      @@loggers = {}
      def logger_for(class_name)
        @@loggers[class_name] ||= configure_logger_for(class_name)
      end
      def configure_logger_for(class_name)
        logger = Logger.new("fly.log")
        logger.progname = class_name.class
        logger
      end
      def info(class_name,str)
        logger_for(class_name).info(str)
      end
      def warn(class_name,str)
        logger_for(class_name).warn(str)
      end
      def error(class_name,str)
        logger_for(class_name).error(str)
      end
    end
  end
end
