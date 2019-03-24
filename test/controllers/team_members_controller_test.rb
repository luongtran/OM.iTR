require 'test_helper'

class TeamMembersControllerTest < ActionController::TestCase
  setup do
    @team = teams(:one)
    @team_member = team_members(:one)
  end

  test "should get index" do
    get :index, params: { team_id: @team }
    assert_response :success
  end

  test "should get new" do
    get :new, params: { team_id: @team }
    assert_response :success
  end

  test "should create team_member" do
    assert_difference('TeamMember.count') do
      post :create, params: { team_id: @team, team_member: @team_member.attributes }
    end

    assert_redirected_to team_team_member_path(@team, TeamMember.last)
  end

  test "should show team_member" do
    get :show, params: { team_id: @team, id: @team_member }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { team_id: @team, id: @team_member }
    assert_response :success
  end

  test "should update team_member" do
    put :update, params: { team_id: @team, id: @team_member, team_member: @team_member.attributes }
    assert_redirected_to team_team_member_path(@team, TeamMember.last)
  end

  test "should destroy team_member" do
    assert_difference('TeamMember.count', -1) do
      delete :destroy, params: { team_id: @team, id: @team_member }
    end

    assert_redirected_to team_team_members_path(@team)
  end
end
