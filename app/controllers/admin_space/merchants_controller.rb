# frozen_string_literal: true

class AdminSpace::MerchantsController < AdminSpace::BaseController
  def index
    @merchants = Domain::Merchant.all
  end

  def new
    @form = MerchantInfo.new
  end

  def edit
    @merchant = Domain::Merchant.find(params[:id])
    @form = MerchantInfo.for_merchant(@merchant)
  end

  def create
    @form = MerchantInfo.new(params)
    result = merchant_service.create(@form)

    if result.success?
      redirect_to action: :index
    else
      @errors = errors_by_codes(result.payload)
      render action: :new
    end
  end

  def update
    @form = MerchantInfo.new(params)

    result = merchant_service.update(params[:id], @form)

    if result.success?
      redirect_to action: :index
    else
      @merchant = Domain::Merchant.find(params[:id])
      @errors = errors_by_codes(result.payload)
      render action: :edit
    end
  end

  private

  def merchant_service
    Domain::MerchantCrudService
  end

  def errors_by_codes(codes)
    codes.map { |code| I18n.t("admin_space.merchants.errors.#{code}") }
  end
end
