class Request < ApplicationRecord
  belongs_to :user

  enum mark_statuses: { unverified: 0, certifiable: 1, unprovable: 2 }

  def mark_statuses
    case mark_status
    when "unverified"
      "未認証"
    when "certifiable"
      "認証"
    when "unprovable"
      "認証不可"
    end
  end
end
