class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
            format: { with: /\A[a-zA-Z0-9_\.]*\z/, message: "only allows letters, numbers, and underscores" }
  

  def name
    if first_name.present? || last_name.present?
      [first_name, last_name].compact.join(' ')
    else
      username
    end
  end

end
