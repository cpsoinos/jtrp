class CompaniesController < ApplicationController
  before_filter :require_internal, except: [:about_us, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule]

  def show
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:notice] = "Changes saved!"
      redirect_to company_about_us_path(@company)
    else
      flash[:error] = "Unable to save changes."
      redirect_to :back
    end
  end

  def about_us
  end

  def consignment_policies
  end

  def service_rate_schedule
  end

  def agent_service_rate_schedule
  end

  protected

  def company_params
    params.require(:company).permit([:slogan, :address_1, :address_2, :city, :state, :zip, :phone, :phone_ext, :website, :logo, :description, :consignment_policies, :service_rate_schedule, :agent_service_rate_schedule, :bootsy_image_gallery_id])
  end

end
