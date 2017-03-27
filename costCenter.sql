--SQLAPPRCH01P  New Branch 
SELECT ldap.dn, detail.EmpNum, detail.ManagerID, detail.FirstName, detail.LastName, detail.MI, department.DepartmentName, position.PositionName, detail.Email, 
                  detail.ManagerEmail, detail.HireDate, detail.ReHireDate, detail.TerminationDate, detail.Type,
                      (SELECT dn
                       FROM      LDAP.dbo.UserObjects AS mgrLDAP
                       WHERE   (mail = detail.ManagerEmail)) AS mgrDN
					   ,job.HOME_DEPARTMENT as costcode
FROM     dbo.ADP_Employee_Detail AS detail INNER JOIN
                  dbo.ADP_Position_Detail AS position ON detail.PositionID = position.PositionID INNER JOIN
                  dbo.ADP_Department_Detail AS department ON detail.DepartmentID = department.DepartmentID 
				  INNER JOIN LDAP.dbo.UserObjects AS ldap ON ldap.employeeID = detail.EmpNum
				  inner join ADP.dbo.PS_JOB_CURRENT as job on job.emplid = detail.EmpNum