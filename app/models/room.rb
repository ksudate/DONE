class Room < ApplicationRecord
  has_many :users, through: :members
  has_many :members, dependent: :destroy
  accepts_nested_attributes_for :members
end
