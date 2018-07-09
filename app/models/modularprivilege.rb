class Modularprivilege < ApplicationRecord
  has_many :rolemodulars
  belongs_to :modular
  belongs_to :privilege
end
