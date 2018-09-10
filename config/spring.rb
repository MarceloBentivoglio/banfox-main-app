%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/services
  config/application.yml\n).each { |path| Spring.watch(path) }
