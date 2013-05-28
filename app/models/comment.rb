class Comment < ActiveRecord::Base
  attr_accessible :body, :show_id, :user_id, :user_name

  # Valdiations
  validates :body, :presence => true
  validates :show_id, :numericality => true, :presence => true
  validates :user_id, :numericality => true, :presence => true
  validates :user_name, :presence => true

  # Associations
  belongs_to :user
  belongs_to :show

  # METHODS
  # Class Methods
  def self.get_latest_show_commits(show_id, number)
    where(:show_id => show_id).order("created_at desc").limit(number)
  end

  # Instance Methods

end
