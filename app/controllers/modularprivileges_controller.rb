class ModularprivilegesController < ApplicationController
  before_action :set_modularprivilege, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, :only => [:new]
  def index
    @modularprivileges = Modularprivilege.all
    @modulars = Modular.all
    @privileges = Privilege.all
  end
  def edit
    @modularprivilege = Modularprivilege.find(params[:id])
  end

  def new
    @modularprivilege = Modularprivilege.new
    @modularprivilege.save(validate: false)
    redirect_to modularprivileges_path
  end

  def create
    @modularprivilege = Modularprivilege.new(modularprivilege_params)
    respond_to do |format|
      if @modularprivilege.save
        format.html { redirect_to modularprivileges_path, notice: '保存成功。' }
      else
        format.html { redirect_to modularprivileges_path}
      end
    end
  end

  def update
    respond_to do |format|
      if @modularprivilege.update(modularprivilege_params)
        if (@modularprivilege.modular_id.to_i > 0) && (@modularprivilege.privilege_id.to_i > 0)
          @modularprivilege.name = @modularprivilege.modular.displyname + ":" + @modularprivilege.privilege.displyname
          @modularprivilege.save
        end
        format.html { redirect_to modularprivileges_path, notice: '保存成功。' }
        format.json { render :index, status: :ok, location: @modularprivilege }
      else
        format.html { redirect_to modularprivileges_path }
        format.json { render json: @modularprivilege.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @modularprivilege.destroy
    respond_to do |format|
      format.html { redirect_to modularprivileges_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_modularprivilege
    @modularprivilege = Modularprivilege.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def modularprivilege_params
    params.require(:modularprivilege).permit(:modular_id, :privilege_id)
  end
end
