class JointDebtor < ApplicationRecord
  belongs_to :seller, optional: true
end
