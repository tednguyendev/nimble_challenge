module Api
  module V1
    module Google
      class FetchResults
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @opts = opts
        end

        def call
          byebug
          # ait
        end

        private

        def ait
          GoogleScrape::Search.fetch_results(opts[:keywords])
        end

        attr_reader :opts
      end
    end
  end
end
