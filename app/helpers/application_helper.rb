module ApplicationHelper
  def fdate(date)
    return if date.nil?

    date.strftime("%m/%d/%Y")
  end

  def page_title
    title = "Golf Handicaps"
    if c = content_for(:header)
      title << " &laquo; #{c}"
    end

    title.html_safe
  end
end
