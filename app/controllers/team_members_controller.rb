class TeamMembersController < ApplicationController
  before_action :set_team, except: [:send_tasks]
  before_action :set_team_member, only: [:show, :edit, :update, :destroy]

  # GET teams/1/team_members
  def index
    @team_members = @team.team_members.order(:created_at).paginate(page: params[:page], per_page: 5)
  end

  # GET teams/1/team_members/1
  def show
  end

  def send_tasks
    task_ids = params[:task_ids]
    emails = params[:emails]
    #emails = emails if !emails.nil?
    if !emails.nil?
      users = User.where("email IN (?)", emails.split(','))
      assign_tasks(task_ids.split(','), users) if users
    end
    @result = {success: true, message: "Assigned tasks successfully"}

  end

  # GET teams/1/team_members/new
  def new
    @team_member = @team.team_members.build
  end

  # GET teams/1/team_members/1/edit
  def edit
  end

  # POST teams/1/team_members
  def create
    @team_member = @team.team_members.build(team_member_params)

    if @team_member.save
      redirect_to(team_team_member_path(@team_member.team, @team_member), notice: 'Team member was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT teams/1/team_members/1
  def update
    if @team_member.update_attributes(team_member_params)
      redirect_to([@team_member.team, @team_member], notice: 'Team member was successfully updated.')
    else
      render action: 'edit'
    end
  end

  # DELETE teams/1/team_members/1
  def destroy
    @team_member.destroy

    redirect_to team_team_members_url(@team)
  end

  private

    def assign_tasks(task_ids, users)
      tasks = Task.where(id: task_ids)
      users.each do |user|
        user.tasks << tasks
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:team_id])
    end

    def set_team_member
      @team_member = @team.team_members.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_member_params
      params.require(:user).permit(:full_name, :email, :password, :avatar, :bio)
    end
end
