class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @users = User.where("id in (select user_id from userroles where role_id in (?)) or id not in (select user_id from userroles where user_id is not null)",get_role_id)
  end
  def edit
    @user = User.find(params[:id])
    @userroles = @user.userroles.all
    @role = Role.where(get_role_sql)
  end

  def new
    @user = User.new
    @userroles = Userrole.where("1=2")
  end


  def create
    if params[:user][:pwd] == params[:user][:pwd_conf]
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          pwd=Userpwd.new(:user_id => @user.id)
          pwd.password = params[:user][:pwd]
          pwd.errpwd = 0
          pwd.nids = 0
          pwd.uptime =Time.new
          pwd.save
          format.html { redirect_to users_path, notice: '保存成功。' }
        else
          format.html { render :new }
        end
      end
    else
      @user = User.new(user_params)
      render :new
    end
  end

  def update
    if params[:user][:pwd] == params[:user][:pwd_conf]
      respond_to do |format|
        if @user.update(user_params)
          userroles = params[:user][:userrole]
          if userroles != nil
            userroles.each do |userrole|
              ur = Userrole.find(userrole)
              if userroles[userrole][:role_id] == "0"
                ur.role_id = nil
              else
                ur.role_id = userroles[userrole][:role_id]
              end
              ur.save(validate: false)
            end
          end
          pwd=@user.userpwd
          pwd.password = params[:user][:pwd]
          pwd.errpwd = params[:errus]
          pwd.nids = params[:nids]
          pwd.uptime =Time.new
          pwd.save
          format.html { redirect_to users_path, notice: '保存成功。' }
          format.json { render :index, status: :ok, location: @role }
        else
          format.html { render :edit }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    else
      render :edit
    end
  end

  def destroy
    pwd=@user.userpwd
    if pwd != nil
      pwd.destroy
    end
    @user.userroles.each do |userrole|
      userrole.destroy
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def show

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :nickname, :sttype, :session_id)
  end
end
