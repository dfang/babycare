module ReservationsHelper
  def date_format(date)
    date.strftime("%Y-%m-%d%P%I:%M").gsub("am", "上午").gsub("pm", "下午")
  end
end
