# spec/services/api/v1/reports/get_keyword_html_string_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::Reports::GetKeywordHtmlString do
  let(:keyword_value) { 'what is a house' }

  describe '#call' do
    before do
      allow(Api::V1::Reports::GetUserAgents).to receive_message_chain(:instance, :random_user_agent).and_return('User Agent 1')
    end

    it 'config the selenum correctly AND returns the HTML source of the Google search results page' do
      expect_any_instance_of(Selenium::WebDriver::Chrome::Options).to receive(:add_argument).with('headless')
      expect_any_instance_of(Selenium::WebDriver::Chrome::Options).to receive(:add_argument).with("--user-agent=User Agent 1")
      expect_any_instance_of(Selenium::WebDriver::Remote::Http::Default).to receive(:read_timeout=).with(180)

      driver_double = double Selenium::WebDriver::Driver
      expect(Selenium::WebDriver).to receive(:for)
        .with(:chrome, http_client: instance_of(Selenium::WebDriver::Remote::Http::Default), options: instance_of(Selenium::WebDriver::Chrome::Options))
        .and_return(driver_double)

      expect(driver_double).to receive_message_chain(:manage, :window, :size=).with(instance_of(Selenium::WebDriver::Dimension))
      expect(driver_double).to receive(:quit)

      expect(driver_double).to receive(:get).with("https://www.google.com/search?q=#{URI.encode(keyword_value)}")
      expect(driver_double).to receive(:page_source).and_return('<html></html>')

      result = described_class.call(keyword_value)

      expect(result.success?).to be_truthy
      expect(result.result).to eq('<html></html>')
    end
  end
end
