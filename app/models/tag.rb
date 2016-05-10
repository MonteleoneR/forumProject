class Tag < ActiveRecord::Base
validates :title, presence: true, uniqueness: true
has_many :categorizations
has_many :posts, through: :categorizations
end