require 'rspec'
require 'vcr'
require 'pry'

require_relative '../discover_feed_service.rb'


VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

describe DiscoverFeedService do


  it "should have an attr_reader for url" do
    discoverer = DiscoverFeedService.new("http://slashdot.org")

    expect(discoverer.request_url).to eq("http://slashdot.org")
  end

  context "#initialize" do
    it "can be instantiated with a string that might be a URL" do
      expect { DiscoverFeedService.new("slashdot") }.to_not raise_error
    end
    it "can be initialized with a valid url" do
      expect { DiscoverFeedService.new("http://slashdot.org") }.to_not raise_error
    end
  end


  context "#result" do
    let(:discoverer) { DiscoverFeedService.new("http://slashdot.org") }

    it "retrieves href for specified url" do
      VCR.use_cassette('get_slashdot_url') do
        expect(discoverer.result.first.href).to eq('http://rss.slashdot.org/Slashdot/slashdot')
      end
    end

    it "retrieves title for specified url" do
      VCR.use_cassette('get_slashdot_url') do
        expect(discoverer.result.first.title).to eq('Slashdot RSS')
      end
    end

    it "retrieves rel for specified url" do
      VCR.use_cassette('get_slashdot_url') do
        expect(discoverer.result.first.rel).to eq('alternate')
      end
    end
    it "retrieves type for specified url" do
      VCR.use_cassette('get_slashdot_url') do
        expect(discoverer.result.first.type).to eq('application/rss+xml')
      end
    end
  end

  # If these cause issues dont' fix!  Just let the rot. ::There be Dragons::

  context "#disco_url" do
    it "prettifies our url" do
      discoverer = DiscoverFeedService.new("http://slashdot.org")
      expected_result = "http://feediscovery.appspot.com/?url=http://slashdot.org"

      expect(discoverer.instance_eval('disco_url')).to eq(expected_result)
    end
  end
end
