require "my_bcycle/version"
require "typhoeus"

module MyBcycle
  InvalidCredentials = Class.new(StandardError)
  CommunicationProblem = Class.new(StandardError)

  class User
    attr_reader :username, :password, :city
    def initialize(city: :austin, username:, password:)
      @city = city
      @username = username
      @password = password
    end

    def statistics_for(time)
      return unless session_token
      response = do_request! Typhoeus::Request.new(
        "https://portal-den.bcycle.com/1/user/trips",
        params: {
          month: time.month,
          year: time.year,
        },
        headers: { 'Bcycle-Session-Token': session_token },
        accept_encoding: "gzip"
      )
      parse_statistics(response.body)
    end

    private

    def parse_statistics(body)
      JSON.parse(body).map do |entry|
        k = Time.parse entry["checkOutDate"]
        v = {
          miles:  entry["miles"],
          duration:  entry["duration"],
          money_saved:  entry["moneySaved"],
        }
        [k, v]
      end.to_h
    end

    def session_token
      @session_token ||= retrieve_token
    end

    def retrieve_token
      cookiefile = Tempfile.new("bcycle-cookie")
      cookie_path = cookiefile.path
      begin
        login_request!(cookie_path)
        token_request!(cookie_path).body[/\A"([a-z0-9\-]{36})"/i, 1]
      end
    ensure
      cookiefile.close
      cookiefile.unlink
    end

    def login_request!(cookie_path)
      login_req = do_request! Typhoeus::Request.new(
        login_url,
        method: :post,
        cookiefile: cookie_path,
        cookiejar: cookie_path,
        body: login_params
      )
      if login_req.body =~ /Invalid UserName/i
        raise InvalidCredentials
      end
    end

    def token_request!(cookie_path)
      do_request! Typhoeus::Request.new(
        token_url,
        cookiefile: cookie_path,
        cookiejar: cookie_path
      )
    end

    def do_request!(request)
      request.on_complete do |response|
        next if response.success?

        if response.timed_out?
          raise CommunicationProblem, "Timeout"
        elsif response.code == 0
          raise CommunicationProblem, response.return_message.to_s
        else
          raise CommunicationProblem, "Got error code #{response.code}"
        end
      end
      request.run
    end

    def login_url
      "https://#{city}.bcycle.com/api/Authenticate"
    end

    def token_url
      "https://#{city}.bcycle.com/api/sessiontoken/get"
    end

    def login_params
      {
        UserName: username,
        Password: password,
      }
    end
  end
end
