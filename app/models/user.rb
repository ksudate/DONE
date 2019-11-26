class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :splints, dependent: :destroy
  validates :line_id, presence: true, uniqueness: true
  validates :access_token, presence: true
end
