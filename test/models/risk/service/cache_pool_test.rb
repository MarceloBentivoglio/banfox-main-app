require 'test_helper' 
class Risk::Service::CachePoolTest < ActiveSupport::TestCase
  class MockedService
  end

  setup do
    Redis.new.flushall
  end
  
  def service_params
    {param_1: 1, param_2: 2}
  end

  def cache_pool
    @cache_pool ||= Risk::Service::CachePool.new(MockedService,  service_params)
  end

  def cache_key
    'risk-service-cachepooltest-mockedservice_param_1param_2_12'
  end

  def mocked_response
    {
      hello_world: 1
    }
  end

  test 'call service' do
    MockedService.expects(:call)
                 .with(service_params)

    cache_pool.call
  end

  test 'set cache for service response' do
    MockedService.stubs(:call).returns(mocked_response)
    cache_pool.cache_engine
               .expects(:set)
               .with(cache_key, mocked_response)

    cache_pool.call
  end

  test 'do not execute the service if cache is set' do
    cache_pool.cache_engine
              .stubs(:get)
              .returns(mocked_response)

    MockedService.expects(:call).never

    cache_pool.call
  end

  test 'execute service and return the expected response' do
    MockedService.stubs(:call).returns(mocked_response)
    response = Risk::Service::CachePool.call(MockedService, service_params)

    expected = {
      :"#{cache_key}" => mocked_response
    }
    assert_equal expected, response
  end

  test 'generate the correct cache key' do
    cache_key = Risk::Service::CachePool.generate_cache_key(MockedService, {param_1: 1, param_2: 2})
    expected_value = 'risk-service-cachepooltest-mockedservice_param_1param_2_12'

    assert_equal cache_key, expected_value
  end
end
