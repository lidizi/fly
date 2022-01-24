# typed: false
module Fly
  module HTTPHelper 
    def create_http 
      http = HTTP
      cookies = cookies || {}
      # http.timeout(2)
      http.cookies(cookies)
    end
    def request(url,**options)
      headers = { 
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:95.0) Gecko/20100101 Firefox/95.0",
      }
      _method = options.fetch(:method,"GET")
      _body = options[:body]
      _data = options[:data]
      _headers = options[:headers]
      _proxy = options[:proxy]
      http = create_http
      http = http.headers(headers.merge(_headers)) if _headers
      http = http.via(_proxy[:host],_proxy[:port]) if _proxy
      Fly::Log.info(self,"request #{_method} #{url} #{_data ? "data" : "body"} => #{_data || _body}")
      Fly::Log.info(self,"body => #{_body}") if _body
      response = ''
      begin
      Timeout.timeout(5){ 
        if _method.upcase == 'GET'
          response = http.get(url,params: _data || {}) 
          else 
          if _body
            response = http.post(url,body: _body.to_json) 
            else 
            response = http.post(url,form: _data || {}) 
          end
        end
        yield(response.code == 200 ? response : nil)
      }
      rescue 
      yield(nil)

      end
    end
  end
end
