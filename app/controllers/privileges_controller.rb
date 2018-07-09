class PrivilegesController < ApplicationController
  before_action :set_privilege, only: [:show, :edit, :update, :destroy]
  def index
    @privileges = Privilege.all
  end
  def edit
    @privilege = Privilege.find(params[:id])
  end

  def new
    @privilege = Privilege.new
  end

  def create
    @privilege = Privilege.new(privilege_params)
    respond_to do |format|
      if @privilege.save
        format.html { redirect_to privileges_path, notice: '保存成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @privilege.update(privilege_params)
        format.html { redirect_to privileges_path, notice: '保存成功。' }
        format.json { render :index, status: :ok, location: @privilege }
      else
        format.html { render :edit }
        format.json { render json: @privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @privilege.destroy
    respond_to do |format|
      format.html { redirect_to privileges_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_privilege
    @privilege = Privilege.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def privilege_params
    params.require(:privilege).permit(:name, :displyname)
  end
end
