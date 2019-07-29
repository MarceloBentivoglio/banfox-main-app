# == Schema Information
#
# Table name: key_indicator_reports
#
#  id         :bigint           not null, primary key
#  input_data :jsonb
#  pipeline   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ttl        :datetime
#  kind       :string
#

module Risk
  #TODO change the name for analysis
  class KeyIndicatorReport < ApplicationRecord
    GRAY_FLAG=-1
    GREEN_FLAG=0
    YELLOW_FLAG=1
    RED_FLAG=2

    self.table_name = 'key_indicator_reports'

    has_and_belongs_to_many :external_data, class_name: 'Risk::ExternalDatum'
    has_many :analyzed_parts
    belongs_to :operation

    def indicators_quantity
      @indicators_quantity ||= {}
      key_indicators.keys.each do |cnpj|
        @indicators_quantity = {
          :"#{cnpj}" => {
            gray: 0,
            green: 0,
            yellow: 0,
            red: 0,
          }
        }
      end
    end

  end
end
