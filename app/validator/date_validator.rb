class Invoice < ActiveRecord::Base

  validate :expiration_date_cannot_be_in_the_past

  def expiration_date_cannot_be_in_the_past
    errors.add(:expiration_date, "can't be in the past") if
      !expiration_date.blank? and expiration_date < Date.today
  end
  
end
