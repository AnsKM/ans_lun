class TravelDetailsController < ApplicationController

  # before_action do |controller|
  #   controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_send_a_comment")
  # end

  before_action :only => [:create] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_content")
  end

  def create
    @travel = @current_user.travel_details.build
    if request.post?
      travel_round_date = params[:travel_single_date].present? ? params[:travel_single_date] : params[:travel_round_date]
      params[:travel_detail][:travel_type] = params[:travel_single_date].present? ? 0 : 1
      params[:travel_detail][:travel_round_date] = travel_round_date
      @travel.update(travel_create_params(params))
      redirect_to travel_detail_path(@travel.id)
    end
  end

  def show
    @travel_detail = TravelDetail.find_by(id: params[:id])
    @locations = Location.near([@travel_detail.to_address_latitude,@travel_detail.to_address_longitude])
  end

  private

  def travel_create_params(params)
    result = params.require(:travel_detail).slice(
        :travel_single_date
    ).permit!
    result.merge(params.require(:travel_detail)
      .permit(:travel_round_date, :from_address, :to_address, :from_address_latitude, :from_address_longitude, :to_address_latitude, :to_address_longitude, :travel_type)
    )
  end

end
