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
    self.table_name = 'key_indicator_reports'

    has_and_belongs_to_many :external_data
  end
end
