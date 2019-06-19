class UserSerializer < ActiveModel::Serializer
  attributes :id   #, :first_name, :last_name
  attribute :email, if: :current_user
  attribute :edit_link, if: :current_user_is_owner

  def edit_link
    edit_user_url(object)
  end

  def current_user_is_owner
    scope == object
  end
end
