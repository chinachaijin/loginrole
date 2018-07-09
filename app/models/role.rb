class Role < ApplicationRecord
  has_many :userroles
  has_many :rolemodulars
end
