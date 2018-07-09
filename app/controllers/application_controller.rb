class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def getrubyroute(user)
    table = ActiveRecord::Base.connection.select_all "SELECT mp.modular_id,mp.privilege_id,m.name as modname,p.name as priname FROM modularprivileges as mp,roles as r,modulars as m,privileges as p,userroles as ur,rolemodulars as rm where ur.user_id = " + user.id.to_s + " and ur.role_id = r.id and r.id = rm.role_id and rm.modularprivilege_id = mp.id and mp.modular_id = m.id and mp.privilege_id = p.id and m.name = '" + request.filtered_parameters[:controller] + "' and p.name = '" + request.filtered_parameters[:action] + "'"
    if table.rows.length == 0
      redirect_to root_path
    end
  end

  def authenticate_action(usaction)
    sessions = Session.where("session_id = ?",session[:session_id])
    if sessions.length > 0
      user = User.where("id = ?",sessions[0].user_id)
      if (user.length != 0) && (user[0].sttype == 1)
        user = user[0]
        table = ActiveRecord::Base.connection.select_all "SELECT mp.modular_id,mp.privilege_id,m.name as modname,p.name as priname FROM modularprivileges as mp,roles as r,modulars as m,privileges as p,userroles as ur,rolemodulars as rm where ur.user_id = " + user.id.to_s + " and ur.role_id = r.id and r.id = rm.role_id and rm.modularprivilege_id = mp.id and mp.modular_id = m.id and mp.privilege_id = p.id and m.name = '" + request.filtered_parameters[:controller] + "'"
        table = JSON.parse(table.to_json)
        table.each do |tb|
          if tb["priname"] == usaction.to_s
            return 1
          end
        end
      end
    end
    return 0
  end

  def get_role_sql
    ddr = getauthenticate_rolearr
    if (ddr[0][0] == 0) && (ddr[1][0] == 0)
      str = " "
    else
      str = ""
      for i in 0..(ddr[0].length - 1)
        str = str + " (sttype >= " + ddr[0][i].to_s + " and up_id >= " + ddr[1][i].to_s  + " ) or"
      end
      str = str[0..(str.length-4)]
    end
    return str
  end

  def get_role_id
    @roles = Role.where(get_role_sql)
    roleid = Array.new
    @roles.each do |role|
      roleid.push(role.id)
    end
    return roleid
  end

  def getauthenticate_rolearr
    sessions = Session.where("session_id = ?",session[:session_id])
    if sessions.length > 0
      user = User.where("id = ?",sessions[0].user_id)
      if (user.length != 0) && (user[0].sttype == 1)
        user = user[0]
        table = Role.where("id in (select role_id from userroles where user_id = ?) and sttype = 0 and up_id = 0",user.id)
        if table.length > 0
          rolearr = Array.new
          rolearr = rolearr.push(Array.new([0]))
          rolearr = rolearr.push(Array.new([0]))
          return rolearr
        end
        table = Role.where("id in (select role_id from userroles where user_id = ?)",user.id).order("sttype")
        rolearr = Array.new
        roletp = Array.new
        roletp = roletp.push(table[0].sttype.to_i)
        roleup = Array.new
        roleup = roleup.push(table[0].up_id.to_i)
        table.each do |tb|
          if roletp[roletp.length - 1] != tb.sttype.to_i
            roletp = roletp.push(tb.sttype.to_i)
            roleup = roleup.push(tb.up_id.to_i)
          end
          if roleup[roleup.length - 1] > tb.up_id.to_i
            roleup[roleup.length - 1] = tb.up_id.to_i
          end
        end
        rolearr = rolearr.push(roletp)
        rolearr = rolearr.push(roleup)
        return rolearr
      end
    end
    return
  end

  def authenticate
    sessions = Session.where("session_id = ?",session[:session_id])
    if sessions.length > 0
      user = User.where("id = ?",sessions[0].user_id)
      if (user.length != 0) && (user[0].sttype == 1)
        if user[0].logtype == 1
          if user[0].session_id == session[:session_id]
            sessions = Session.where("user_id = ?",user[0].id)
            sessions.each do |sess|
              if sess.session_id != session[:session_id]
                sess.destroy
              end
            end
          else
            redirect_to root_path
          end
        else
          sessions = Session.where("user_id = ? and updated_at < ?",user[0].id,Time.new - 1.day)
          sessions.each do |sess|
            if sess.session_id != session[:session_id]
              sess.destroy
            end
          end
        end
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
