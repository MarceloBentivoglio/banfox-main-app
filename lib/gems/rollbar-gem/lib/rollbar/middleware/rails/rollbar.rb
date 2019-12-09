require 'rollbar/request_data_extractor'
require 'rollbar/exception_reporter'

module Rollbar
  module Middleware
    module Rails
      class RollbarMiddleware
        include RequestDataExtractor
        include ExceptionReporter

        def initialize(app)
          @app = app
        end

        def call(env)
          self.request_data = nil

          Rollbar.reset_notifier!

          env['rollbar.scope'] = scope = fetch_scope(env)

          Rollbar.scoped(scope) do
            begin
              #Rollbar.notifier.enable_locals
              response = @app.call(env)

              #if (framework_exception = env['action_dispatch.exception'])
              #  report_exception_to_rollbar(env, framework_exception)
              #end

              response
            rescue Exception => exception
              #report_exception_to_rollbar(env, exception)
              trace_exception = TraceException.create(
                message: exception.message,
                instance_variables: exception.instance_variables,
                instance_variable_names: exception.instance_variable_names,
                rack_session: env['rack.session'],
                request_method: env['REQUEST_METHOD'],
                query_hash: env['rack.request.query_hash'],
                request_params: env["action_dispatch.request.request_parameters"],
                query_params: env["action_dispatch.request.query_parameters"],
                path: env["REQUEST_PATH"]
              )

              SlackMessage.new('GRF3V8DL4', "trace_exceptions/#{trace_exception.id}\nmessage: #{exception.message} ").send_now

              raise exception
            ensure
            end
          end
        end

        def fetch_scope(env)
          # Scope a new notifier with request data and a Proc for person data
          # for any reports that happen while a controller is handling a request

          {
            :request => proc { request_data(env) },
            :person => person_data_proc(env),
            :context => proc { context(request_data(env)) }
          }
        end

        def request_data(env)
          Thread.current[:'_rollbar.rails.request_data'] ||= extract_request_data(env)
        end

        def request_data=(value)
          Thread.current[:'_rollbar.rails.request_data'] = value
        end

        def extract_request_data(env)
          extract_request_data_from_rack(env)
        end

        def person_data_proc(env)
          block = proc { extract_person_data_from_controller(env) }
          return block unless defined?(ActiveRecord::Base) && ActiveRecord::Base.connected?

          proc do
            begin
              ActiveRecord::Base.connection_pool.with_connection(&block)
            rescue ActiveRecord::ConnectionTimeoutError
              {}
            end
          end
        end

        def context(request_data)
          return unless request_data[:params]

          route_params = request_data[:params]
          # make sure route is a hash built by RequestDataExtractor
          return route_params[:controller].to_s + '#' + route_params[:action].to_s if route_params.is_a?(Hash) && !route_params.empty?
        end
      end
    end
  end
end
