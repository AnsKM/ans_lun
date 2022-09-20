class AddColumnToListing < ActiveRecord::Migration[5.2]
  def change
    add_column :listings, :from_address, :string
    add_column :listings, :from_address_latitude, :string
    add_column :listings, :from_address_longitude, :string
  end
end
