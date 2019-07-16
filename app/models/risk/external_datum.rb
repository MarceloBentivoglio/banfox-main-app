# == Schema Information
#
# Table name: external_data
#
#  id         :bigint           not null, primary key
#  source     :string
#  raw_data   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  query      :jsonb
#  ttl        :datetime
#

module Risk
  class ExternalDatum < ApplicationRecord
    has_and_belongs_to_many :key_indicator_reports
  end
end
