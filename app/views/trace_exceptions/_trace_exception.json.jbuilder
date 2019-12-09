json.extract! trace_exception, :id, :message, :trace, :instance_variables, :instance_variable_names, :rack_session, :request_method, :query_hash, :request_params, :query_params, :path, :env, :created_at, :updated_at
json.url trace_exception_url(trace_exception, format: :json)
