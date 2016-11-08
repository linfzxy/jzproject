require 'mysql2'  
begin  
  db = Mysql2::Client.new(
	:host     => '127.0.0.1', # 主机
	:username => 'root',      # 用户名
	:password => 'a8566834',    # 密码
	:database => 'test',      # 数据库
	:encoding => 'utf8'       # 编码
	) 
  db.query("SET NAMES utf8")  
  db.query("drop table if exists tb_test")  
  db.query("create table tb_test (id int,text LONGTEXT) ENGINE=MyISAM DEFAULT CHARSET=utf8")  
  db.query("insert into tb_test (id, text) values (1,'first line'),(2,'second line')")  
  printf "%d rows were inserted\n",db.affected_rows  
  rslt = db.query("select text from tb_test")  

  end