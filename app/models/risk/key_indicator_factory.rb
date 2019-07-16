module Risk
  class KeyIndicatorFactory
    attr_accessor :key_indicator

    def build(referee)
      @key_indicator = KeyIndicator.new(
        code: referee.code,
        title: referee.title,
        description: referee.description,
        params: referee.params,
      )
    end

  end
end
