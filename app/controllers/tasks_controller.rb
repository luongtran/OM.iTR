class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_tasks, only: [:index]

  # GET /tasks
  # GET /tasks.json
  def index

  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.created_by = current_user.id

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: I18n.t('task.created_success') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def completed_tasks
    task_ids = params[:mark_task_ids]
    TasksUser.where(task_id: task_ids.split(','), user_id: current_user.id).update_all(status: "done")
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: I18n.t('task.updated_success')  }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: I18n.t('task.deleted_success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:task_name, :description, :created_by)
    end


    def get_tasks
      @keyword = params[:keyword].present? ? params[:keyword].strip : ''
      role = current_user.role
      query = nil
      case role
      when 'admin'
        query = current_user.my_tasks.where("task_name LIKE ?", "%#{@keyword}%")
      when 'manager'
        query = current_user.my_tasks.where("task_name LIKE ?", "%#{@keyword}%")
      else
        query = current_user.tasks.where("task_name LIKE ?", "%#{@keyword}%")
      end
      @tasks = query.paginate(page: params[:page], per_page: 10)

    end
end
