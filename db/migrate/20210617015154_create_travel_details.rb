class CreateTravelDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :travel_details do |t|
      t.string :travel_round_date
      t.integer :travel_type
      t.string :from_address
      t.string :to_address
      t.string :from_address_latitude
      t.string :from_address_longitude
      t.string :to_address_latitude
      t.string :to_address_longitude
      t.string :person_id

      t.timestamps
    end
  end
end
