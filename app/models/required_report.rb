class RequiredReport < ApplicationRecord
  # Convert empty name and agency fields to null
  nilify_blanks only: [:name, :agency]
end
