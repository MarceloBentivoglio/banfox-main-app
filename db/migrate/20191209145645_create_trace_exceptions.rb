class CreateTraceExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :trace_exceptions do |t|
      t.text :message
      t.jsonb :trace
      t.jsonb :instance_variables
      t.jsonb :instance_variable_names
      t.jsonb :rack_session
      t.string :request_method
      t.jsonb :query_hash
      t.jsonb :request_params
      t.jsonb :query_params
      t.string :path
      t.string :env

      t.timestamps
    end
  end
end
