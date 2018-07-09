class ModularsController < ApplicationController
  before_action :set_modular, only: [:show, :edit, :update, :destroy]
  def index
    @modulars = Modular.all
  end
  def edit
    @modular = Modular.find(params[:id])
  end

  def new
    @modular = Modular.new
  end

  def create
    @modular = Modular.new(modular_params)
    respond_to do |format|
      if @modular.save
        format.html { redirect_to modulars_path, notice: '保存成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @modular.update(modular_params)
        format.html { redirect_to modulars_path, notice: '保存成功。' }
        format.json { render :index, status: :ok, location: @privilege }
      else
        format.html { render :edit }
        format.json { render json: @privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @modular.destroy
    respond_to do |format|
      format.html { redirect_to modulars_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_modular
    @modular = Modular.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def modular_params
    params.require(:modular).permit(:name, :displyname)
  end
end
