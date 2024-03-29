class Post < ApplicationRecord
    has_many :comments, dependent: :destroy
    belongs_to :category
    belongs_to :model1
    validates :title, presence: true, length: {minimum: 5}   
    validates :category_id, presence: true
end

