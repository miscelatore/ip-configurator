class AddLastSeenDateOnAssignedAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :assigned_address, :last_seen_date, :datetime
  end
end
