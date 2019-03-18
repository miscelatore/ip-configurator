class DefineInitialAppTablesFromOldApp < ActiveRecord::Migration[4.2]
  def change

    
    reversible do |dir|
      dir.up do
        execute <<-SQL                  
          -- Trasformazione attributo ip della tabella address da bytea in text
          alter table address rename COLUMN ip TO ip_old;
          alter table address ADD COLUMN ip text not null;
          update address set ip = substr(ip_old::TEXT, 3);
          
          -- Modifica dei contenuto attributo ip della tabella address per 
          -- rimonzione del prefisso \x
          
          -- Normalizzazione attributi tabella address
          alter table address rename COLUMN date_created TO created_at;
          alter table address rename COLUMN last_updated TO updated_at;
          alter table address DROP COLUMN version;
          alter table address ADD COLUMN lock_version integer not null default 0; 
          
          -- Normalizzazione attributi tabella assigned_address
          alter table assigned_address rename COLUMN date_created TO created_at;
          alter table assigned_address rename COLUMN last_updated TO updated_at;
          alter table assigned_address DROP COLUMN version;
          alter table assigned_address ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella collector
          alter table collector rename COLUMN date_created TO created_at;
          alter table collector rename COLUMN last_updated TO updated_at;
          alter table collector DROP COLUMN version;
          alter table collector ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella collector_port
          alter table collector_port rename COLUMN date_created TO created_at;
          alter table collector_port rename COLUMN last_updated TO updated_at;
          alter table collector_port DROP COLUMN version;
          alter table collector_port ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella hardware
          alter table hardware rename COLUMN date_created TO created_at;
          alter table hardware rename COLUMN last_updated TO updated_at;
          alter table hardware DROP COLUMN version;
          alter table hardware ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella location
          alter table location rename COLUMN date_created TO created_at;
          alter table location rename COLUMN last_updated TO updated_at;
          alter table location DROP COLUMN version;
          alter table location ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella location_port
          alter table location_port rename COLUMN date_created TO created_at;
          alter table location_port rename COLUMN last_updated TO updated_at;
          alter table location_port DROP COLUMN version;
          alter table location_port ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella network
          alter table network rename COLUMN date_created TO created_at;
          alter table network rename COLUMN last_updated TO updated_at;
          alter table network DROP COLUMN version;
          alter table network ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella operator
          alter table operator rename COLUMN date_created TO created_at;
          alter table operator rename COLUMN last_updated TO updated_at;
          alter table operator DROP COLUMN version;
          alter table operator ADD COLUMN lock_version integer not null default 0;
          
          -- Normalizzazione attributi tabella registration_code
          alter table registration_code rename COLUMN date_created TO created_at;
          alter table registration_code rename COLUMN last_updated TO updated_at;
          alter table registration_code DROP COLUMN version;
          alter table registration_code ADD COLUMN lock_version integer not null default 0;
          
        SQL
      end
      dir.down do
        execute <<-SQL
          -- noop
        SQL
      end
    end
    
  end
end
