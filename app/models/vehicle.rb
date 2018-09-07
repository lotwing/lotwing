class Vehicle < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :shapes, through: :tags

  has_one :current_parking_tag, -> { where(active: true) }, class_name: 'Tag'
  
  has_one :parking_space, through: :current_parking_tag, source: :shape
end