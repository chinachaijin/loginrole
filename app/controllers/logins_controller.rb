class LoginsController < ApplicationController
  def index
    @user = User.new
  end
  def create #注册
    if params[:user]["username"] != ""
      if params[:user]["pwd"] != ""
        if params[:user]["pwd"] == params[:user]["pwd_confirmation"]
          user = User.find_by(:username => params[:user]["username"])
          if user == nil
            user = User.new
            user.nickname = params[:user]["nickname"]
            user.username = params[:user]["username"]
            user.sttype = 0
            user.save
            pwd = Userpwd.new
            pwd.user_id = user.id
            pwd.password = params[:user]["pwd"]
            pwd.save
            redirect_to logins_path, notice: '注册成功！'
          else
            redirect_to logins_path, notice: '该用户名已被使用！'
          end
        else
          redirect_to logins_path, notice: '两次输入的密码不一致！'
        end
      else
        redirect_to logins_path, notice: '密码不能为空！'
      end
    else
      redirect_to logins_path, notice: '用户名不能为空！'
    end
  end
  def new
    @user = User.new
  end
  def loginuser #登录
    user = User.find_by(:username => params[:user]["username"])
    if (user != nil) && (user.sttype == 1)
      pwd = user.userpwd
      if pwd.authenticate(params[:user]["pwd"]) == false
        redirect_to logins_path, notice: '账号或密码错误！'
      else
        if user.logtype == 1
          sessuser = User.find_by(:session_id => session[:session_id])
          if sessuser != nil
            sessuser.session_id = nil
            sessuser.save
          end
          user.session_id = session[:session_id]
          user.save
        end
        sessions = Session.where("session_id = ?",session[:session_id])
        if sessions.length > 0
          sessions = sessions[0]
          sessions.user_id = user.id
          sessions.updated_at = Time.new
          sessions.save
        else
          sessions = Session.new
          sessions.session_id = session[:session_id]
          sessions.user_id = user.id
          sessions.save
        end

        redirect_to roles_path, notice: '密码正确！'
      end
    else
      redirect_to logins_path, notice: '账号被锁定！'
    end
  end
  def unloginuser #登出
    sessions = Session.where("session_id = ?",session[:session_id])
    if sessions.length > 0
      user = User.where("id = ?",sessions[0].user_id)
      if user.length != 0
        if user[0].logtype == 1
          user[0].session_id = nil
          user[0].save
          sessions = Session.where("user_id = ?",user[0].id)
          sessions.each do |sess|
            sess.destroy
          end
        else
          sessions.each do |sess|
            sess.destroy
          end
        end
      else
        sessions.each do |sess|
          sess.destroy
        end
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
