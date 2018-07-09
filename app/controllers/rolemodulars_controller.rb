class RolemodularsController < ApplicationController
  before_action :set_rolemodular, only: [:destroy]
  def new
    role = Role.find(params[:rid])
    rolemodular = role.rolemodulars.new
    rolemodular.save(validate: false)
    redirect_to edit_role_path(role)
  end
  def destroy
    @rolemodular.destroy
    respond_to do |format|
      role = Role.find(@rolemodular.role_id)
      format.html { redirect_to edit_role_path(role), notice: '删除成功' }
      format.json { head :no_content }
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rolemodular
    @rolemodular = Rolemodular.find(params[:id])
  end
end
