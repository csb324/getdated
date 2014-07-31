class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite

  validates :msg, presence: true
end
