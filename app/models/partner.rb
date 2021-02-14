class Partner < ApplicationRecord
  # MATERIALS should probably be in a different helper class,
  # or even in its own model depending on how much extra info will be required in the future
  MATERIALS = %w[wood carpet tiles]

  validate :validate_materials

  # this makes sense to have as an array validator extending the rails validation classes
  def validate_materials
    if (unknown_materials = (materials - MATERIALS))
      unknown_materials.each do |material|
        errors.add(:materials_list, material + " is an unknown material")
      end
    end
  end

end
