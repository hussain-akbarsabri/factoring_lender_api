# frozen_string_literal: true

# UserSerializer
class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :created_at
end
