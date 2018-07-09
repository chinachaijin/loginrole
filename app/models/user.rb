class User < ApplicationRecord
  has_one :userpwd
  has_many :userroles
end
