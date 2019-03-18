class AddNtpServersOnNetwork < ActiveRecord::Migration[4.2]
  def change
	add_column :network, :ntp_servers, :string
  end
end
