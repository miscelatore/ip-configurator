class AddLastSeenDateOnAssignedAddress < ActiveRecord::Migration
  def change
    add_column :assigned_address, :last_seen_date, :datetime
  end
end
