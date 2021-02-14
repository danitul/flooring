class Partner < ApplicationRecord
  # MATERIALS should probably be in a different helper class,
  # or even in its own model depending on how much extra info will be required in the future
  MATERIALS = %w[wood carpet tiles]

  validate :validate_materials

  scope :within_radius, -> (lat, lng) { where("acos(sin(lat) * sin(?) + cos(lat) * cos(?) * cos(lng - ?)) * 6371 <= radius", lat, lat, lng) }
  scope :with_expertise, -> (expertise) { where('?=ANY(materials)', expertise) }

  scope :order_by_rating, -> { order(rating: :desc) }
  scope :order_by_distance_from_home, -> { order(:distance) }

  # formula for distance between two (lat, lng) pairs
  # d = acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lon1-lon2))
  # distance_km ≈ radius_km * distance_radians ≈ 6371 * d
  # or if shorter distances required d = 2*asin(sqrt((sin((lat1-lat2)/2))^2 + cos(lat1)*cos(lat2)*(sin((lon1-lon2)/2))^2))
  # see https://stackoverflow.com/questions/5031268/algorithm-to-find-all-latitude-longitude-locations-within-a-certain-distance-fro
  # also, using a geolocation gem such as https://github.com/geokit/geokit-rails
  # might prove useful, didn't get to research it in more depth for this assignment as the current implementation seemed more straightforward.
  def self.select_with_distance_from_home(lat, lng)
    query_string = "*, (acos(sin(lat) * sin(:home_lat) + cos(lat)*cos(:home_lat)*cos(lng - :home_lng) ) * 6371) AS distance"
    select(sanitize_sql_array([query_string, home_lat: lat, home_lng: lng]))
  end

  # this makes sense to have as an array validator extending the rails validation classes
  def validate_materials
    if (unknown_materials = (materials - MATERIALS))
      unknown_materials.each do |material|
        errors.add(:materials_list, material + " is an unknown material")
      end
    end
  end

end
