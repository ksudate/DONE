class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :splints, dependent: :destroy
  has_many :rooms, through: :members
  has_many :members

  validates :line_id, presence: true, uniqueness: true
  validates :access_token, presence: true
end
