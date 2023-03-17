module GoogleScrape
  class Search
    # 5 => 10s
    # 10 => 5s
    # 20 => 3s
    def self.fetch_results(keywords)
      a1 = Time.now
      results = []

      keywords.each do |keyword|
        results << fetch(keyword)
      end

      a2 = Time.now
      p('==============')
      p('==============')
      p('==============')
      p('==============')
      p(results.map { |z| z.code })
      p(a2 - a1)
      results

      # if response.ok?
        # return {
        #   access_token: response['access_token'],
        #   token_type: response['token_type'],
        #   expires_in: response['expires_in']
        # }
      # end

      # nil
    end

    def self.fetch(keyword)
      # sleep(delay)
      url = "https://www.google.com/search"
      Typhoeus.get(url, params: { q: keyword }, followlocation: true)
    end
  end
end
