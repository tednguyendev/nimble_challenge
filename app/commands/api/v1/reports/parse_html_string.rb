module Api
  module V1
    module Reports
      class ParseHtmlString
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(html_string)
          @html_string = html_string
        end

        def call
          doc = Nokogiri::HTML(html_string)

          if doc.css('#captcha-form').length >= 1
            {
              have_captcha: true
            }
          else
            total_results, search_time = get_total_results_and_search_time(doc)

            {
              have_captcha: false,
              data: {
                total_results: total_results,
                search_time: search_time,
                ad_words_count: get_ad_words_count(doc),
                links_count: get_links_count(doc)
              }
            }
          end
        end

        private

        def get_total_results_and_search_time(doc)
          total_results = nil
          search_time = nil

          result_stats_text = doc.css('#result-stats').text.strip

          if result_stats_text.length.positive?
            result_stats_ary = result_stats_text.split(" ")
            total_results = result_stats_ary[1].gsub(".",",").gsub(",","").to_i
            search_time = result_stats_ary[-2].gsub("(","").gsub(",",".").to_f
          end

          [total_results, search_time]
        end

        def get_ad_words_count(doc)
          normal_ads_count = doc.css('.U3A9Ac.qV8iec').count

          # sometimes there are 2 of them, but only show 1 in the page
          shopping_ads_count = doc.css('.fryEeb.U3A9Ac.irmCpc').count > 0 ? 1 : 0
          normal_ads_count + shopping_ads_count
        end

        def get_links_count(doc)
          doc.css('a')
             .map { |l| l['href'] }
             .select { |l| l.is_a?(String)}
             .uniq
             .count
             #  .select { |l| l.is_a?(String) && "http".in?(l) && !".google.com".in?(l) }
        end

        attr_reader :html_string
      end
    end
  end
end
