class Post < ApplicationRecord
  validates :line_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
