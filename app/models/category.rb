class Category < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :posts
    has_and_belongs_to_many :subscribers
end
