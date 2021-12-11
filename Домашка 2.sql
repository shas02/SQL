select * from client;
select FirstName, LastName, City from client;
select * from client order by Age;
select * from client order by Age desc;
select * from client where FirstName like '__o%';

-- 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select * from client where length(FirstName) < 6;

-- 2.Вибрати львівські відділення банку.
select * from department where DepartmentCity = 'Lviv';

-- 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education = 'high' order by LastName;

-- 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select * from application order by idApplication desc limit 5 offset 0;
select * from application order by idApplication desc limit 5 offset 10;

-- 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select * from client where LastName like '%ov' or LastName like '%OVA';

-- 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select * from client 
join department on client.Department_idDepartment = department.idDepartment
where DepartmentCity = 'Lviv'
order by idClient;	

-- 7.Знайти унікальні імена клієнтів.
select distinct FirstName from client;

-- 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select * from client
join application on client.idClient = application.Client_idClient
where application.Sum > 5000 and CreditState like 'n%' and Currency like 'g%'
order by idClient;

-- 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.

select count(distinct idClient), idDepartment, DepartmentCity
from client
join department on client.Department_idDepartment = department.idDepartment
group by idDepartment; 

-- select count(distinct idClient), idDepartment, DepartmentCity
from client
join department on client.Department_idDepartment = department.idDepartment
where DepartmentCity like 'l%'
group by idDepartment; 

-- 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select max(Sum), CreditState, concat(firstname, ' ', lastname) as Name  
from application
join client on application.Client_idClient = client.idClient
group by Name
order by name;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
select count(idApplication) as numberOfApplications, concat(firstname, ' ', lastname) as Name  
from application
join client on application.Client_idClient = client.idClient
group by Name
order by numberOfApplications;

-- 12. Визначити найбільший та найменший кредити.
select max(sum) as maxCredit, min(sum) as minCredit
from application;

-- 13. Порахувати кількість кредитів для клієнтів, які мають вищу освіту.
select count(idApplication) as numberOfCredits, idClient, concat(firstname, ' ', lastname) as Name, Education  
from application
join client on application.Client_idClient = client.idClient
where Education like 'h%' 
-- and CreditState like 'n%'
group by idClient
order by numberOfCredits;

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

 select avg(sum) as avgSumOfCredits, idClient, concat(firstname, ' ', lastname) as Name
 from application
 join client on application.Client_idClient = client.idClient
 group by idClient
 order by avgSumOfCredits desc
 limit 1 offset 0;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей

select idDepartment, DepartmentCity, CountOfWorkers, sum(Sum) as sumOfCredits
from client
join department on client.Department_idDepartment = department.idDepartment
join application on client.idClient = application.Client_idClient 
group by idDepartment
order by sumOfCredits desc
limit 1 offset 0;

-- 16. Вивести відділення, яке видало найбільший кредит.

select max(Sum), idDepartment, DepartmentCity, CountOfWorkers
from client
join department on client.Department_idDepartment = department.idDepartment
join application on client.idClient = application.Client_idClient; 

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.

update application
set Sum = 6000
where Client_idClient in (select idClient from client where Education = 'high');

select * 
from application
-- where Client_idClient in (select idClient from client where Education = 'high');
join client on application.Client_idClient = client.idClient
where Education = 'high';

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
update client
set City = 'Kyiv'
where Department_idDepartment in (select idDepartment from department where DepartmentCity = 'Kyiv');

select * 
from client
where Department_idDepartment in (select idDepartment from department where DepartmentCity = 'Kyiv');
 
-- 19. Видалити усі кредити, які є повернені.
delete from application where CreditState = 'Returned' limit 1000;

select * from application;

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete application FROM application
JOIN client c ON application.Client_idClient = c.idClient
WHERE substr(c.LastName,2,1) IN ('a', 'e', 'i', 'o', 'u');

-- 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT DepartmentCity, sum FROM application
JOIN client c ON application.Client_idClient = c.idClient
JOIN department d ON c.Department_idDepartment = d.idDepartment
WHERE d.DepartmentCity = 'Lviv' AND Sum > 5000;

select sum(Sum) AS creditsSum, idDepartment, DepartmentCity 
from application
join client on application.Client_idClient = client.idClient
right join department on client.Department_idDepartment = department.idDepartment
where DepartmentCity = 'Lviv' and Sum > 5000;

-- 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select * 
from client
where idClient in (select Client_idClient from application where CreditState = 'returned' AND sum >5000);
 
-- 23.Знайти максимальний неповернений кредит.
select max(sum) from application where CreditState like 'N%';

-- 24.Знайти клієнта, сума кредиту якого найменша
select min(sum), idClient, FirstName, LastName
from client
join application on client.idClient = application.Client_idClient

-- 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT * FROM application
WHERE Sum > (SELECT avg(Sum) FROM application);

-- 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select * from client 
where city = (select city
from client
join application on client.idClient = application.Client_idClient
group by Client_idClient
having count(idApplication)
order by count(idApplication) desc
limit 1 offset 0);

-- 27. Місто клієнта з найбільшою кількістю кредитів
select city
from client
join application on client.idClient = application.Client_idClient
group by Client_idClient
having count(idApplication)
order by count(idApplication) desc
limit 1 offset 0;  
