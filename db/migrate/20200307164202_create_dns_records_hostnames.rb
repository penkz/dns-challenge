class CreateDnsRecordsHostnames < ActiveRecord::Migration[6.0]
  def change
    create_table :dns_records_hostnames, id: false do |t|
      t.references(:dns_record, null: false, foreign_key: true)
      t.references(:hostname, null: false, foreign_key: true)
    end
  end
end
