create procedure testLogin @username varchar(30), @password varchar(30)
as
select * from Usuarios where Username = @username and Password = @password