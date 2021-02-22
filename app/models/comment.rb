class Comment < ApplicationRecord
  belongs_to :board
  belongs_to :user

  validates :body, presence: true, length: { maximum: 65_535 }
end
