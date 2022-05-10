class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy

  has_one_attached :profile_image #profile_imageという名前でActiveStorageでプロフィール画像を保存できるように設定

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
end

def self.search_for(content, method)
  if method == 'perfect'
    User.where(name: content)
  elsif method == 'forward'
    User.where('name LIKE?', content+'%')
  elsif method == 'backward'
    User.where('name LIKE?', '%'+content)
  else
    User.where('name LIKE?', '%'+content+'%')
  end
end

end
