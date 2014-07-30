class UserSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :tracks
  has_many :tracks
end
