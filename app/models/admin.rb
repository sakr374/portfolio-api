class Admin < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :validatable,
         jwt_revocation_strategy: JwtDenylist
end