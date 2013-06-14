class Show < ActiveRecord::Base

  attr_accessible :user_id, :title, :description, :display_preferences, :display_preferences_password, 
                  :contributor_preferences, :contributor_preferences_password, :need_review, :cameos_attributes,:show_tag

  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  validates :display_preferences, :presence => true
  validates :contributor_preferences, :presence => true

  # Associations
  belongs_to :director, :class_name => "User", :foreign_key => "user_id"
  has_many :cameos, :dependent => :destroy
  accepts_nested_attributes_for :cameos
  has_many :comments, :dependent => :destroy

  # Scope
  scope :public_shows, where(:display_preferences => "public")  
  scope :public_and_shows, where('display_preferences LIKE ? OR display_preferences LIKE ?','public', 'private')  
end
