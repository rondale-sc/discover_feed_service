class DiscoverFeedService
  require 'curb'
  require 'json'

  attr_reader :request_url

  def initialize(request_url)
    @request_url = request_url
  end

  def result
    perform_request
  end

  private

  def disco_url
    "http://feediscovery.appspot.com/?url=#{self.request_url}"
  end

  def perform_request
    response = Curl::Easy.perform(disco_url) do |curl|
      curl.headers["User-Agent"] = "1kpl.us/ruby"
      curl.max_redirects = 5
      curl.timeout = 30
      curl.follow_location = true
      curl.on_redirect {|easy,code|
        @url = location_from_header(easy.header_str) if easy.response_code == 301
      }
    end

    JSON.parse(response.body_str).map {|e| OpenStruct.new e}
  end
end

__END__

class DiscoverFeedService

  attr :url, :result
  def initialize(options={})
    @url = options[:url]
  end

  def perform(options={})
    @url = options[:url] || url
    @url = "http://#{@url}" unless @url.include? "http"

      get_response
  end

  def self.perform(options)
    self.new.perform(options)
  end

  protected

  def perform_request(follow = false)
  end

  def disco_url
  end

  def get_response
    response = perform_request
    binding.pry

  end

  def location_from_header(header)
    header =~ /.*Location:\s(.*)\r/
      $1
  end

end
