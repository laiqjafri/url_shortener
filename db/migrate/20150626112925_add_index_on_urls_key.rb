class AddIndexOnUrlsKey < ActiveRecord::Migration
  def change
    add_index :urls, :key, :unique => true
  end
end
