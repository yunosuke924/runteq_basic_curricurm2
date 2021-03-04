class User < ApplicationRecord
  mount_uploader :avatar_image, AvatarImageUploader
  authenticates_with_sorcery!
  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :board

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true, uniqueness: true

  validates :last_name, presence: true, length: { maximum: 255 }
  validates :first_name, presence: true, length: { maximum: 255 }

  enum role: { general: 0, admin: 1 }

  # レシーバーのユーザーインスタンスのIDは引数のオブジェクトのuser_iと等しいかどうかを判別
  def own?(object)
    id == object.user_id
  end

  # 引数で渡す掲示板をブックマークする
  def bookmark(board)
    bookmark_boards << board
  end

  # 引数で渡す掲示板をブックマークから外す
  def unbookmark(board)
    bookmark_boards.destroy(board)
  end

  def bookmarked?(board)
    Bookmark.find_by(board_id: board.id, user_id: id)
  end
end
