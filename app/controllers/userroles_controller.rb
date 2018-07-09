class UserrolesController < ApplicationController
  before_action :set_userrole, only: [:destroy]
  def new
    if params[:id].to_i > 0
      user = User.find(params[:id])
      userrole = user.userroles.new
      userrole.save(validate: false)
      redirect_to edit_user_path(user)
    elsif params[:rid].to_i > 0
      role = Role.find(params[:rid])
      userrole = role.userroles.new
      userrole.save(validate: false)
      redirect_to edit_role_path(role)
    else
      redirect_to users_path
    end
  end
  def destroy
    @userrole.destroy
    respond_to do |format|
      if params[:type] == "1"
        user = User.find(@userrole.user_id)
        format.html { redirect_to edit_user_path(user), notice: '删除成功' }
        format.json { head :no_content }
      else
        role = Role.find(@userrole.role_id)
        format.html { redirect_to edit_role_path(role), notice: '删除成功' }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_userrole
    @userrole = Userrole.find(params[:id])
  end
end
