class Risk::AnalyzedPart < ApplicationRecord
  belongs_to :key_indicator_report, class_name: 'Risk::KeyIndicatorReport'
end
