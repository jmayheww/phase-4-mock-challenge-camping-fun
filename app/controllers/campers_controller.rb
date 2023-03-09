class CampersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_message_unprocessable_entity
  def index
    campers = Camper.all
    render json: campers, status: :ok
  end

  def show
    camper = found_camper
    render json: camper, serializer: CamperActivitiesSerializer
  end

  def create
    camper = Camper.create!(camper_params)
    render json: camper, status: :created
  end

  private

  def camper_params
    params.permit(:name, :age)
  end

  def found_camper
    Camper.find(params[:id])
  end

  def render_not_found_response
    render json: { error: 'Camper not found' }, status: :not_found
  end

  def render_error_message_unprocessable_entity(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
