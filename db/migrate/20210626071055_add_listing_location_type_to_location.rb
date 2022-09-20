class AddListingLocationTypeToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :listing_location_type, :integer, default: 0		
  end
end
