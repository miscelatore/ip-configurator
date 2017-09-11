class AddNtpServersOnNetwork < ActiveRecord::Migration
  def change
	add_column :network, :ntp_servers, :string
  end
end
