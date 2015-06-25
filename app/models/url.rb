class Url < ActiveRecord::Base
  KEY_LENGTH = 5 #the length will actually be around 4/3 of this number
  before_save :set_key
  validates_presence_of :url
  validates_format_of   :url, :with => URI::regexp(%w(http https))

  def set_key
    self.key = SecureRandom.urlsafe_base64(KEY_LENGTH)
    self.set_key if Url.exists?(key: self.key)
  end
end
