# == Schema Information
#
# Table name: travel_details
#
#  id                     :bigint           not null, primary key
#  travel_round_date      :string(255)
#  travel_type            :integer
#  from_address           :string(255)
#  to_address             :string(255)
#  from_address_latitude  :string(255)
#  from_address_longitude :string(255)
#  to_address_latitude    :string(255)
#  to_address_longitude   :string(255)
#  person_id              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class TravelDetail < ApplicationRecord
  belongs_to :person
  TRAVELTYPE = ['single', 'round']
  enum travel_type: TRAVELTYPE
end
