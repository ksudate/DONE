class Splint < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 60 }
  validates :sp_number, presence: true
  validates :kpt, presence: true
end
