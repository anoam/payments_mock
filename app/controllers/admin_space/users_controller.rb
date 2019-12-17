# frozen_string_literal: true

class AdminSpace::UsersController < AdminSpace::BaseController
  def index
    @users = UserManagement::User.all
  end

  def new
    @form = UserForm.new
  end

  def create
    @form = UserForm.new(params)
    result = manage_user_service.create_admin(@form)

    if result.success?
      redirect_to action: :index
    else
      @errors = errors_by_codes(result.payload)
      render action: :new
    end
  end

  def edit
    @form = UserForm.new
    @user_id = params[:id]
  end

  def update
    @form = UserForm.new(params)
    @user_id = params[:id]

    result = manage_user_service.update(@user_id, @form)

    if result.success?
      redirect_to action: :index
    else
      @errors = errors_by_codes(result.payload)
      render action: :edit
    end
  end

  private

  def manage_user_service
    UserManagement::ManageUserService
  end

  def errors_by_codes(codes)
    codes.map { |code| I18n.t("admin_space.users.errors.#{code}") }
  end
end
