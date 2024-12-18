# frozen_string_literal: true

class Spree::Admin::UserPasswordsController < Devise::PasswordsController
  helper "spree/base"

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Store

  helper "spree/admin/navigation"
  layout "spree/layouts/admin"

  skip_before_action :require_no_authentication, only: [ :create ]

  # Overridden due to bug in Devise.
  #   respond_with resource, location: new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, location: spree.login_path
  #
  def create
    user = Spree::User.find_by(email: params[resource_name][:email])
    user.update(tmp_store_id: current_store.id)

    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    set_flash_message(:notice, :send_instructions) if is_navigational_format?

    if resource.errors.empty?
      respond_with resource, location: admin_user_path(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

  private

  # NOTE: as soon as this gem stops supporting Solidus 3.1 if-else should be removed and left only include
  if defined?(::Spree::Admin::SetsUserLanguageLocaleKey)
    include ::Spree::Admin::SetsUserLanguageLocaleKey
  else
    def set_user_language_locale_key
      :admin_locale
    end
  end
end
