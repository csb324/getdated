class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite

  validates :msg, presence: true

  def mark_as_read
    read = true
  end

end
