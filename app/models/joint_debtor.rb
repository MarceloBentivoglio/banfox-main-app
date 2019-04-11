class JointDebtor < ApplicationRecord
  belongs_to :seller, optional: true
  validates :name, :birthdate, :mobile, :documentation, :email, presence: true
  validates_with DateValidator, attr: :birthdate
  validates :mobile, format: { with: /\A[1-9]{2}9\d{8}\z/, message: "precisa ser um número de celular válido" }
  validates_with CpfValidator, attr: :documentation
  validates :email, email: true
  before_validation :clean_inputs, :downcase_words

  private
  def clean_inputs
    %i{mobile documentation}.each do |attr|
      self.__send__(attr).gsub!(/[^0-9A-Za-z]/, '') unless self.__send__(attr).nil?
    end
  end

  def downcase_words
    name.downcase!
    email.downcase!
  end
end
