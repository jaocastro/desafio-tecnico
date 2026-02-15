class JobsController < ApplicationController
  before_action :authenticate!, only: %i[create update destroy]
  before_action :set_job, only: %i[show update destroy]

  def index
    jobs = Job.order(updated_at: :desc)
    jobs = jobs.where(status: "published") unless current_user
    jobs = jobs.where(status: params[:status]) if params[:status].present? && current_user
    jobs = jobs.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?

    render json: jobs
  end

  def show
    if !current_user && @job.status != "published"
      render json: { error: "Registro não encontrado" }, status: :not_found
      return
    end

    render json: @job
  end

  def create
    job = Job.new(job_params)
    job.save!

    render json: job, status: :created
  end

  def update
    @job.update!(job_params)

    render json: @job
  end

  def destroy
    @job.destroy!

    head :no_content
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :status, :location, :employment_type)
  end
end
