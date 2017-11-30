module ReservationsHelper
  def date_format(date)
    if date.today?
      date.strftime("今天%P%I:%M").gsub("am", "上午").gsub("pm", "下午")
    elsif (date - 1.day).today?
      date.strftime("明天%P%I:%M").gsub("am", "上午").gsub("pm", "下午")
    elsif (date - 2.day).today?
      date.strftime("后天%P%I:%M").gsub("am", "上午").gsub("pm", "下午")
    else
      date.strftime("%Y-%m-%d%P%I:%M").gsub("am", "上午").gsub("pm", "下午")
    end
  end
end
