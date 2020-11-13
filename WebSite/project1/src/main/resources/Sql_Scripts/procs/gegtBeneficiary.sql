create procedure getBeneficiaryDataByAccount @accountId varchar(30)
as
SELECT * FROM Persona, Beneficiarios WHERE Persona.Id IN (SELECT PersonaId FROM Beneficiarios WHERE Beneficiarios.CuentaAsociadaId = 37) AND Beneficiarios.CuentaAsociadaId = 37