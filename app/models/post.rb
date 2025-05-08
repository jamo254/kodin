class Post < ApplicationRecord  
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  # ActionText content
  has_rich_text :content
  
  # Tagging
  acts_as_taggable_on :tags
  
  validates :title, presence: true
  validates :slug, uniqueness: true, allow_blank: true
  
  before_validation :generate_slug
  
  scope :published, -> { where(published: true) }
  scope :free, -> { where(premium: false) }
  scope :premium, -> { where(premium: true) }
  
  def reading_time
    words_per_minute = 200
    text = content&.to_plain_text || ""
    (text.split.size.to_f / words_per_minute).ceil
  end
  
  def to_param
    slug
  end
  
  def self.find_by_param(param)
    find_by(slug: param)
  end
  
  def self.search(query)
    if query.present?
      where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
    else
      all
    end
  end
  
  private
  
  def generate_slug
    return if slug.present?
    
    base_slug = title.to_s.parameterize
    temp_slug = base_slug
    counter = 0
    
    while Post.where(slug: temp_slug).exists?
      counter += 1
      temp_slug = "#{base_slug}-#{counter}"
    end
    
    self.slug = temp_slug
  end
end