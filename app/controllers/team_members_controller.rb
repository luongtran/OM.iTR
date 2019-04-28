class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, except: [:send_tasks, :send_emails]
  before_action :set_team_member, only: [:show, :edit, :update, :destroy]

  # GET teams/1/team_members
  def index
    @team_members = @team.team_members.order(:created_at).paginate(page: params[:page], per_page: 5)
  end

  def email_list
    return redirect_to root_path if current_user.staff?
    @keyword = params[:keyword].present? ? params[:keyword].strip : ''

    if @keyword.blank?
      @team_members = @team.team_members.order('id desc').paginate(page: params[:page], per_page: 100)
    else
      @team_members = @team.team_members.where('full_name LIKE ? or email LIKE ? ', "%#{@keyword}%","%#{@keyword}%").order('id desc').paginate(page: params[:page], per_page: 100)
    end

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
    flash[:success] = "Task assigned successfully"
    
    redirect_to tasks_path

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
      redirect_to(team_team_member_path(@team_member.team, @team_member), notice: I18n.t('team_members.created_success'))
    else
      render action: 'new'
    end
  end

  # PUT teams/1/team_members/1
  def update
    if @team_member.update_attributes(team_member_params)
      redirect_to([@team_member.team, @team_member], notice: I18n.t('team_members.updated_success'))
    else
      render action: 'edit'
    end
  end

  # DELETE teams/1/team_members/1
  def destroy
    @team_member.destroy

    redirect_to team_team_members_url(@team)
  end

  def send_emails
    content = params[:email_content][:content]
    subject = params[:subject]
    @email_content = EmailContent.create(email_params)
    receivers = params[:receivers].present? ? params[:receivers] : current_user.guests
    return redirect_to root_path if current_user.staff?

    return unless content.present?

    upload_attachments

    receivers.split(',').each do |receiver|
      AdminMailer.notification_email(current_user.full_name, receiver, current_user.email, subject, content, @email_content.mail_attachments).deliver_now
    end

    flash[:success] = "Email sent successfully"

    respond_to do |format|
      format.json { render json: @email_content.to_json }
    end   
  end

  private

  def upload_attachments
    if params[:attachments]
      params[:attachments].each do |attachment|
        @email_content.mail_attachments.create!(file_attach: attachment)
      end
    end
  end

  def email_params
    params.require(:email_content).permit(:content)
  end

  def assign_tasks(task_ids, users)
    puts "================ TEST ================="
    tasks = Task.where(id: task_ids)
    users.each do |user|
      user.tasks << tasks
      user.save
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
    params.require(:user).permit(:full_name, :email, :password, :role, :bio)
  end
end
