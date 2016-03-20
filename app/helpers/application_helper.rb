module ApplicationHelper
  def fdate(date)
    return if date.nil?

    date.strftime("%m/%d/%Y")
  end
end
