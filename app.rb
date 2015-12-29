require "sinatra/base"

module App
  class Main < Sinatra::Base

    configure do
      enable :logging
      set :raise_errors, true
    end

    before do
      logger.datetime_format = "%Y/%m/%d @ %H:%M:%S "
      logger.level = Logger::INFO
    end

    get '/' do
      logger.debug "debug message"
      logger.info "info message"
      port = ENV['VCAP_APP_PORT']
      ip = ENV['CF_INSTANCE_IP']
      cport = ENV['CF_INSTANCE_PORT']
      "\n<h1>Hello VMWorld from #{ip} (#{cport})!!</h1>\n"
    end

    get "/broken" do
      logger.debug "trying broken service"
      `ps -AF | grep -m1 "ruby" | awk '{print $2;}' | (read pid; kill -9 $pid)`
    end
    
    get "/systemcrash" do
      logger.debug "trying broken service"
      Kernel.exit!
    end
    run!
  end

end

