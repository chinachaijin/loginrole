class RolesController < ApplicationController
  before_action :authenticate
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Role.where(get_role_sql)
    #@roles = Role.all
  end

  def edit
    @users = User.where("id in (select user_id from userroles where role_id in (?)) or id not in (select user_id from userroles where user_id is not null)",get_role_id)
    @modularprivileges = Modularprivilege.where("name is not null and id in (select modularprivilege_id from rolemodulars where role_id in (?))",get_role_id)
    @role = Role.find(params[:id])
    @userroles = @role.userroles.all
    @rolemodulars = @role.rolemodulars.all
    ddr = getauthenticate_rolearr
    if (ddr[0][0] == 0) && (ddr[1][0] == 0)
      str = 0
    else
      str = ddr[1][0]
      for i in 0..(ddr[0].length - 1)
        if ddr[1][i] < str
          str = ddr[1][i]
        end
      end
    end
    @roleselect = str
    @rolearr = ddr[0][0]
  end

  def new
    @users = User.all
    @modularprivileges = Modularprivilege.where("name is not null")
    @role = Role.new
    @roleselect = Role.all
    @rolearr = ddr[0][0]
  end

  def create
    @role = Role.new(role_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: '保存成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        userroles = params[:role][:userrole]
        if userroles != nil
          userroles.each do |userrole|
            ur = Userrole.find(userrole)
            if userroles[userrole][:user_id] == "0"
              ur.user_id = nil
            else
              ur.user_id = userroles[userrole][:user_id]
            end
            ur.save(validate: false)
          end
        end
        userroles = params[:role][:rolemodular]
        if userroles != nil
          userroles.each do |userrole|
            ur = Rolemodular.find(userrole)
            if userroles[userrole][:modularprivilege_id] == "0"
              ur.modularprivilege_id = nil
            else
              ur.modularprivilege_id = userroles[userrole][:modularprivilege_id]
            end
            ur.save(validate: false)
          end
        end
        format.html { redirect_to roles_path, notice: '保存成功。' }
        format.json { render :index, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role.userroles.each do |userrole|
      userrole.destroy
    end
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name, :remark, :sttype, :up_id)#
  end
end
