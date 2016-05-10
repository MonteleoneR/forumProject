class Post < ActiveRecord::Base
    
    belongs_to :user
    validates :user, presence: true
    validates :title, presence: true
    validates :body, presence: true
    has_many :categorizations
    has_many :tag, through: :categorization
    attr_accessor :tag_titles
end
