config = Rails.root.join('config', 'redis_browser.yml')
settings = YAML.load(ERB.new(IO.read(config)).result)
RedisBrowser.configure(settings)
