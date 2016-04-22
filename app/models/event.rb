class Event < ActiveRecord::Base
  has_many :users, through: :attendees
  has_many :attendees, dependent: :destroy
  has_many :comments, dependent: :destroy
  # has_many :attendees, through: :users
  belongs_to :user

  # require input for the following fields
  validates :name, :date, :city, :state, presence: true

  # validate submitted 'date' using the good_date function (created below)
  validate :good_date, on: :create

  before_save do
    self.city.capitalize
  end

  # Looks at the instance of each event and looks to see if the user_id (passed through the parameter) is included in event attendee user_id list.
  def is_attending?(id)
    self.attendees.pluck(:user_id).include?(id)
  end

  # Method that prohibits input date to be in the past (envoked above)
  def good_date
    # Unless if similar to "if/not". This statement says if this comparison is false then add this message to error array
    if date
      errors.add(:date, "Event can't be scheduled for the past") unless self.date >= Date.today
    else
      errors.add(:date,) unless self.date != nil
    end

  end

end
