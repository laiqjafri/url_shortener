class Url < ActiveRecord::Base
  ITEMS_PER_PAGE = 20
  KEY_LENGTH     = 5 #the length will actually be around 4/3 of this number
  before_save :set_key
  validates_presence_of :url
  validates_format_of   :url, :with => /(^((http|https):\/\/).+)/i, :message => "is not valid"
  validates_format_of   :url, :with => URI::regexp(%w(http https)), :message => "is not valid" #Check for url with scheme only

  def set_key
    self.key = SecureRandom.urlsafe_base64(KEY_LENGTH)
    self.set_key if Url.exists?(key: self.key)
  end

  def shortened_url
    File.join Rails.application.config.base_url, self.key
  end
end
