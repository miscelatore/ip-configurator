class VisitorsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @active_ip = AssignedAddress.active.count
    @ip_seen_today = AssignedAddress.active.seen_today.count
    @ip_no_more_seen = AssignedAddress.active.no_more_seen.count
    @registered_user = Operator.all.count
  end
end
