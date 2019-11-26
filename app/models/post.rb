class Post < ApplicationRecord
<<<<<<< HEAD
  # belongs_to :user
=======
  belongs_to :user
>>>>>>> b3d6c7a24d368f7b90b93dba8663a9bfedef9579
  validates :line_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
