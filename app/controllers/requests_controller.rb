class RequestsController < ApplicationController
  include RequestsHelper

  before_action :authorize
  before_action :set_request, only: [:show, :status]

  # GET /requests
  def index
    @requests = Request.all.order(:created_at).reverse
  end

  # GET /requests/1
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # POST /requests
  def create
    @request = Request.new(request_params)
    @request.created_by = session[:associate_id]
    @request.tags = params['request']['tags'].reject(&:empty?).join(', ') rescue nil

    respond_to do |format|
      if @request.save
        # create a sidekiq request
        RequestWorker.perform_async(@request.id, "#{Rails.root}/spec/features")

        format.html { redirect_to @request, notice: 'Request was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def status
    render json: { report: report_details }
  end

  def download_report_pdf
    set_request
    send_file "#{Rails.root}/spec/features/#{@request.id}/request_report-#{@request.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  private
    def report_details
      status = @request.status || 'Unknown'

      { status: status, status_label: status_label(@request) }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:tags, :status, :created_by, :description, :solution_id)
    end
end
