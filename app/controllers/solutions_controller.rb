class SolutionsController < ApplicationController
  before_action :authorize
  before_action :set_solution,  only: [:edit, :update, :membership, :prerequisite, :update_solution_configurations]

  # GET /solutions
  def index
    @solutions = Solution.all.order('created_at desc')
  end

  # GET /solutions/1/edit
  def edit
    build_solution_configurations(@solution)
  end

  # GET /solutions/new
  def new
    @solution = Solution.new

    build_solution_configurations(@solution)
  end

  # POST /solutions
  def create
    @solution = Solution.new(solution_params)
    @solution.created_by = session[:associate_id]

    respond_to do |format|
      if @solution.save
        format.html { redirect_to solutions_path, notice: 'Solution was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @solution.update(solution_params.merge(updated_by: session[:associate_id]))
        format.html { redirect_to edit_solution_path(@solution), notice: 'Solution was successfully updated.' }
      else
        format.html do
          redirect_to edit_solution_path(@solution),
            flash: { danger: @solution.errors.full_messages.join("\n").html_safe }
        end
      end
    end
  end

  def membership
    if params[:reason] == 'join'
      @solution.associates << Associate.where(id: session[:associate_id])

      message = 'You successfully joined this Solution'
    else
      @solution.associates.delete(Associate.where(id: session[:associate_id]))

      message = 'You successfully left this Solution'
    end

    redirect_to edit_solution_path(@solution), notice: message
  end


  def prerequisite
    description = @solution.configuration_by_key('prerequisite')

    render json: { prerequisite: description }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.includes(:solution_configurations).find(params[:id])
    end

    def build_solution_configurations(solution)
      if solution.solution_configurations.blank?
        solution.solution_configurations.build(key: 'email')
        solution.solution_configurations.build(key: 'prerequisite')
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solution_params
      params.require(:solution).permit(
        :name, solution_configurations_attributes: [:key, :value]
      )
    end
end
