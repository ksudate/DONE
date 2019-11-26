class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :splints, dependent: :destroy
end
