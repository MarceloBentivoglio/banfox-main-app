class Invoice < ApplicationRecord
  belongs_to :seller, class_name: "Client"
end
