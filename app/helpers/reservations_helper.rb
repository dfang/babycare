# frozen_string_literal: true

module ReservationsHelper
  # TODO
  # FIXME
  def date_format(date)
    if date.today?
      date.strftime('今天%P%I:%M').gsub('am', '上午').gsub('pm', '下午')
    elsif (date - 1.day).today?
      date.strftime('明天%P%I:%M').gsub('am', '上午').gsub('pm', '下午')
    elsif (date - 2.days).today?
      date.strftime('后天%P%I:%M').gsub('am', '上午').gsub('pm', '下午')
    else
      date.strftime('%Y-%m-%d%P%I:%M').gsub('am', '上午').gsub('pm', '下午')
    end
  end

  def build_children_options(options)
    avatar = if options[:gender] == 'male'
                        '/boy.png'
                     else
                        '/girl.png'
                     end
    options.merge!({
      email: "wx_user_#{SecureRandom.hex}@wx_email.com",
      password: SecureRandom.hex,
      avatar: avatar
    })
  end
end
