# 微信卡券 会员卡
# https://mp.weixin.qq.com/wiki/15/de148cc4b5190c80002eaf4f6f26c717.html

module WxApp
  module WxCard
    extend self
    include WxApp::WxCommon

    def create_membership_card
      url = "/card/create?access_token=ACCESS_TOKEN"
      conn = get_conn
    end

    def get_membership_card_approval_status
      url = "/card/get?access_token=TOKEN"
      conn = get_conn
      resp= conn.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
      end
    end

    def get_membership_card_detail(card_id)
      url ="/card/get?access_token=TOKEN"
			conn = get_conn
			resp = conn.post do |req|
				req.url url
        req.headers['Content-Type'] = 'application/json'
				req.body = {card_id: card_id}
			end
			resp
    end

		# 添加到测试白名单
		def add_to_whitelist_for_testing
			url = "/card/testwhitelist/set?access_token=TOKEN"
		end


		# 激活会员卡有三种方式，具体查看文档
		def activate_member_card
			url = "/card/membercard/activate?access_token=TOKEN"
		end



		# 查询Code接口: 可以查询当前code是否可以被核销并检查code状态
		def check_member_card_availabity
			url = "/card/code/get?access_token=TOKEN"
		end


		# 获取用户已领取的卡券
		def get_member_card_list
			url = "/card/user/getcardlist?access_token=TOKEN"
		end

		# 拉取会员信息（积分查询）接口
		def get_member_card_detail
			url = "/card/membercard/userinfo/get?access_token=TOKEN"

		end
  end
end
