create procedure getAccounts  @username varchar(30)
as
select * from CuentaAhorros where Id in (select CuentaId from UsuariosVer where UserId = (select Usuarios.Id from Usuarios where Usuarios.Username = @username))