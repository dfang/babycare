# frozen_string_literal: true

# browser gem hack
module Browser
  class Wechat < Base
    def id
      :wechat
    end

    def name
      'Wechat'
    end

    def match?
      ua =~ /MicroMessenger/
    end
  end
end

module Browser
  class Base
    def wechat?
      Wechat.new(ua).match?
    end
  end
end
