module GoogleScrape
  class Search
    # 5 => 10s
    # 10 => 5s
    # 20 => 3s
    def self.fetch_results(keywords)
      hydra = Typhoeus::Hydra.new(max_concurrency: 10)

      requests = keywords.map { |keyword|
        request = Typhoeus::Request.new(
          "https://www.google.com/search?q=#{keyword}",
          method: :get,
          followlocation: true
        )
        hydra.queue(request)
        request
      }
      hydra.run
      requests

      # if response.ok?
        # return {
        #   access_token: response['access_token'],
        #   token_type: response['token_type'],
        #   expires_in: response['expires_in']
        # }
      # end

      # nil
    end
  end
end
