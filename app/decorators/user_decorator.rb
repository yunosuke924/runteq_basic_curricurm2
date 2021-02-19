class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    # self.first_name + " " + self.last_name
    "#{last_name} #{first_name}"
  end
end
