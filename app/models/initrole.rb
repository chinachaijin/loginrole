class Initrole < ApplicationRecord
  def self.init
    modular = [["用户名","users"],["角色","roles"],["模块","modulars"],["动作","privileges"],["模块权限","modularprivileges"]]
    privilege = [["列表","index"],["新增","new"],["创建","create"],["显示","show"],["修改","edit"],["更新","update"],["删除","destroy"]]
    user = [["系统管理员","admin","admin","1","0"]]
    role = [["系统管理角色","系统最高权限","0","0"]]
    user.each do |u|
      us = User.new
      us.username = u[1]
      us.nickname = u[0]
      if u[3] == "1"
        us.sttype = 1
      else
        us.sttype = 0
      end
      if u[4] == "1"
        us.logtype = 1
      else
        us.logtype = 0
      end
      us.save
      pwd = Userpwd.new
      pwd.user_id = us.id
      pwd.password = u[1]
      pwd.errpwd = 0
      pwd.nids = 0
      pwd.uptime =Time.new
      pwd.save
    end
    role.each do |u|
      us = Role.new
      us.name = u[0]
      us.remark = u[1]
      if u[2].to_i >= 0
        us.sttype = u[2].to_i
      else
        us.sttype = 20
      end
      if u[3].to_i >= 0
        us.up_id = u[3].to_i
      else
        us.up_id = 20
      end
      us.save
    end
    modular.each do |u|
      us = Modular.new
      us.name = u[1]
      us.displyname = u[0]
      us.save
    end
    privilege.each do |u|
      us = Privilege.new
      us.name = u[1]
      us.displyname = u[0]
      us.save
    end
    privilege = Privilege.all
    modular = Modular.all
    modular.each do |mod|
      privilege.each do |pri|
        us = Modularprivilege.new
        us.modular_id = mod.id
        us.privilege_id = pri.id
        us.save
        us.name =  us.modular.displyname + ":" + us.privilege.displyname
        us.save
      end
    end
    #注册权限锁定
    us = Modular.new
    us.name = "logins"
    us.displyname = "注册"
    us.save
    modularid = us.id
    privilege.each do |pri|
      if pri.name == "new"
        us = Modularprivilege.new
        us.modular_id = us
        us.privilege_id = pri.id
        us.save
        us.name =  us.modular.displyname + ":" + us.privilege.displyname
        us.save
      end
    end
    #结束
    role = Role.all
    modularprivilege = Modularprivilege.all
    role.each do |r|
      modularprivilege.each do |mp|
        us = Rolemodular.new
        us.role_id = r.id
        us.modularprivilege_id = mp.id
        us.save
      end
    end
    user = User.all
    user.each do |u|
      role.each do |r|
        ur = Userrole.new
        ur.user_id = u.id
        ur.role_id = r.id
        ur.save
      end
    end
  end
end