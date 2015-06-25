require 'rails_helper'

RSpec.describe Url, type: :model do
  it "has none to begin with" do
    expect(Url.count).to eq 0
  end

  it "will test an empty url" do
    url = Url.create
    expect(url.valid?).to be false
    expect(Url.count).to eq 0

    url = Url.create :url => "http://"
    expect(url.valid?).to be false
    expect(Url.count).to eq 0
  end

  it "will test an invalid url" do
    url = Url.create :url => "test-url"
    expect(url.valid?).to be false
    expect(Url.count).to eq 0
  end

  it "will save a valid url with http" do
    url = Url.create :url => "http://l@iq.com"
    expect(Url.count).to eq 1
    expect(Url.first.url).to eql "http://l@iq.com"
  end

  it "will save a valid url with https" do
    url = Url.create :url => "https://l@iq.com"
    expect(Url.count).to eq 1
    expect(Url.first.url).to eql "https://l@iq.com"
  end

  it "will test that set_key is called on save" do
    url = Url.new :url => "http://l@iq.com"
    expect(url).to receive(:set_key).once
    url.save
  end

  it "will test url has a key present?" do
    url = Url.create :url => "http://l@iq.com"
    expect(Url.count).to eq 1
    expect(Url.first.key.present?).to be true
  end

  it "will test shortened_url" do
    url = Url.create :url => "http://l@iq.com"
    expect(url.shortened_url).to eq (File.join(Rails.application.config.base_url, url.key))
  end
end
