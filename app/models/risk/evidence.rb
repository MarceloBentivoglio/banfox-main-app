# == Schema Information
#
# Table name: evidences
#
#  id             :bigint           not null, primary key
#  input_data     :jsonb
#  collected_data :jsonb
#  referee_name   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

module Risk
  class Evidence < ApplicationRecord
    self.table_name = 'evidences'
  end
end
