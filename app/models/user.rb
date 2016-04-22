class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :events_attending, through: :attendees, source: :event
  has_many :comments, dependent: :destroy

  has_secure_password

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :first_name, :last_name, :email, :city, :state,
  presence: true

  validates :first_name, :last_name, length: { in: 2..20 }

  validates :email,uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
