class Post < ApplicationRecord
  belongs_to :user
  validates :line_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :deadline, presence: true
  validates :rank, presence: true
end
