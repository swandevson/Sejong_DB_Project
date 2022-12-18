USE master
GO


IF EXISTS (
	SELECT name
	FROM sys.databases
	WHERE name = N'beerShop_DB'
)
DROP DATABASE beerShop_DB
GO

CREATE DATABASE beerShop_DB
GO

USE beerShop_DB
GO





/*
DROP TABLE dbo.order_log
DROP TABLE dbo.dist_manager
DROP TABLE dbo.employee
DROP TABLE dbo.cart
DROP TABLE dbo.rank
DROP TABLE dbo.consumer
DROP TABLE dbo.beer_sell
DROP TABLE dbo.beer
DROP TABLE dbo.category
DROP TABLE dbo.distributor
GO
*/




create table category(

	ctg_ID		varchar(3),
	ctg_name	varchar(20),

	primary key (ctg_ID)
);
GO


delete from category;

insert into category values ('001', 'Pale Larger')
insert into category values ('002', 'Pilsner')
insert into category values ('003', 'Vienna Larger')
insert into category values ('004', 'Bock')
insert into category values ('005', 'Dark Larger')
insert into category values ('006', 'Pale Ale')
insert into category values ('007', 'IPA')
insert into category values ('008', 'Double IPA')
insert into category values ('009', 'Red Ale')
insert into category values ('010', 'Velgian Ale')
insert into category values ('011', 'Gueuze')
insert into category values ('012', 'Bitter')
insert into category values ('013', 'Stout')
insert into category values ('014', 'Porter')

select * from category
select * from category order by ctg_ID desc;




create table distributor(
	dist_name		varchar(20) not null,
	location		varchar(20),
	manager_name	varchar(20),

	primary key(dist_name)
);
GO



delete from distributor;

insert into distributor values ('Ballast Point', 'America', 'James Rostish');
insert into distributor values ('Ganadara Brewery', 'Moongyung', 'Kim Gun Woo');
insert into distributor values ('Amazing Brewery', 'Seoul', 'Sim Min Gyu');
insert into distributor values ('Chill hops', 'Seoul', 'Son Seung Min');
insert into distributor values ('Weihenstephan', 'German', ' Rita Heuser');
insert into distributor values ('Paulaner', 'German', 'Tomas Mueller');
insert into distributor values ('Toppling Goliath', 'America', 'Machle Jim');
insert into distributor values ('Hidden Track', 'Seoul', 'Min Chan Hong');
insert into distributor values ('Firestone Walker', 'America', 'Jack Daniel');
GO

select * from distributor;
select * from distributor order by dist_name;
GO



create table dist_manager(
	belong_dist_name	varchar(20),
	manager_name		varchar(20),
	manager_tel			char(13) check ( len(manager_tel) = 11 or len(manager_tel) = 13 ),

	foreign key(belong_dist_name) references distributor(dist_name)
		on update cascade,
	primary key(belong_dist_name, manager_name)
);
GO

create trigger [dbo].trg_manager_tel
on [dbo].dist_manager 
after insert
as
BEGIN
	declare @tel varchar(14)
	select @tel = substring(manager_tel, 1, 3) + '-' +  substring(manager_tel, 4, 4) + '-' +  substring(manager_tel, 8, 4) from inserted
	update dist_manager set manager_tel = @tel
		where manager_tel = (select manager_tel from inserted)	
END
GO


delete from dist_manager;

insert into dist_manager values ('Ballast Point', 'James Rostish', '01012345678');
insert into dist_manager values ('Ganadara Brewery', 'Kim Gun Woo', '01014236545');
insert into dist_manager values ('Amazing Brewery', 'Sim Min Gyu', '010-7654-1246');
insert into dist_manager values ('Chill hops', 'Son Seung Min', '010-3462-1245');
insert into dist_manager values ('Weihenstephan', 'Rita Heuser', '01078902438');
insert into dist_manager values ('Paulaner', 'Tomas Mueller', '01010462385');
insert into dist_manager values ('Toppling Goliath', 'Machle Jim', '01013157456');
insert into dist_manager values ('Hidden Track', 'Min Chan Hong', '01035212467');
insert into dist_manager values ('Firestone Walker', 'Jack Daniel', '01025229467');
GO




create table beer(
	beer_ID			varchar(5) not null,
	beer_name		varchar(30) not null,
	dist_name		varchar(20) not null,
	ctg_ID			varchar(3),
	ABV				decimal(3,1) check (0 <= ABV and ABV <= 100),
	price			int not null check (price > 0),
	
	primary key (beer_ID),
	foreign key (ctg_ID) references category
		on delete set null 
		on update cascade,
	foreign key (dist_name) references distributor
		on update cascade
);
GO

delete from beer;

insert into beer values ('01423', 'Psuedo Sue', 'Toppling Goliath', '008', 8.3, 17000);
insert into beer values ('01415', 'Victory at sea', 'Ballast Point', '013', 10.8, 15800);
insert into beer values ('01487', 'Paulaner Hefe-WeiBbier ', 'Paulaner', '012', 4.9, 4800);
insert into beer values ('01573', 'King Sue', 'Toppling Goliath', '008', 7.8, 18000);
insert into beer values ('02132', 'Parabola 2022', 'Firestone Walker', '013', 14.1, 27000);
insert into beer values ('02412', 'Weihenstephan Vitus', 'Weihenstephan', '006', 4.8, 6000)
insert into beer values ('03415', 'Weihenstephan Cristal', 'Weihenstephan', '001', 4.5, 5000);
insert into beer values ('06712', 'Anniversary 25', 'Firestone Walker', '013', 11.4, 21000);
insert into beer values ('01342', 'First Love', 'Amazing Brewery', '007', 7.4, 9500);

select beer_ID, beer_name, dist_name, ctg_ID, ABV, format(price, '#,#') as price from beer;
select beer_ID, beer_name, dist_name, ctg_ID, ABV, format(price, '#,#') as price from beer 
	where dist_name = 'Toppling Goliath'
	order by price;


GO




create table beer_sell(
	beer_ID			varchar(5) not null,
	dist_name		varchar(20),
	stock			int not null check (stock >= 0),

	foreign key(beer_ID) references beer
		on delete cascade 
		on update cascade,
	foreign key(dist_name) references distributor
		on update no action,
	primary key (beer_ID)
	
);


delete from beer_sell

insert into beer_sell values ('01423', 'Toppling Goliath', 100);
insert into beer_sell values ('01415', 'Ballast Point', 43);
insert into beer_sell values ('01487', 'Paulaner', 120);
insert into beer_sell values ('01573', 'Firestone Walker',100);
insert into beer_sell values ('02132', 'Weihenstephan', 100);
insert into beer_sell values ('02412', 'Weihenstephan', 100);
insert into beer_sell values ('03415', 'Weihenstephan', 69);
insert into beer_sell values ('06712', 'Firestone Walker', 33);
insert into beer_sell values ('01342', 'Amazing Brewery', 48);

select * from beer_sell


GO


create type dollar 
from int
GO

create table rank(
	rank_ID				varchar(2),
	rank_name			varchar(17) check (rank_name in ('part-time', 'staff', 'junior manager', 'senior manager', 'assistant manager', 'manager')),
	wage				dollar check (wage >= 0),

	primary key (rank_ID)
);

delete from rank;

insert into rank values ('01', 'part-time', 7800);
insert into rank values ('02', 'staff', 8400);
insert into rank values ('03', 'junior manager', 11000);
insert into rank values ('04', 'senior manager', 15000);
insert into rank values ('05', 'assistant manager', 20000);
insert into rank values ('06', 'manager', 30000);

select rank_ID, rank_name, wage, format(wage*12, '#,#') as salary from rank;
GO



create table employee(
	employee_ID		varchar(3),
	employee_name	varchar(20),
	employee_tel	varchar(14),
	career			tinyint check (career >= 0),
	rank_ID			varchar(2),

	primary key (employee_ID),
	foreign key (rank_ID) references rank(rank_ID) on delete set null on update cascade
);
GO

create trigger [dbo].trg_employee_tel
on [dbo].employee 
after insert
as
BEGIN
	declare @tel varchar(14)
	select @tel = substring(employee_tel, 1, 3) + '-' +  substring(employee_tel, 4, 4) + '-' +  substring(employee_tel, 8, 4) from inserted
	update employee set employee_tel = @tel
		where employee_tel = (select employee_tel from inserted)	
END
GO


delete from employee;

insert into employee values ('013', 'Jane', '01015254621', 0, '01');
insert into employee values ('015', 'Mary', '01053869384', 1, '01');
insert into employee values ('012', 'John', '01034526582', 1, '01');
insert into employee values ('103', 'Paul', '01011572314', 2, '02');
insert into employee values ('501', 'Masy', '01076689322', 10, '06');
insert into employee values ('302', 'Karson', '01058385613', 4, '04');
	

select * from employee;

GO




create table consumer(
	csm_ID			varchar(20) not null,
	csm_password	varchar(20) not null,
	csm_name		varchar(20) not null,
	csm_sex			varchar(6) check (csm_sex in ('male', 'female')),
	reg_date		varchar(10) not null, -- 하이픈 또는 슬래시
	csm_tel			varchar(14),
	csm_adress		varchar(30),
	
	primary key(csm_ID)
);
GO

create trigger [dbo].trg_csm_tel
on [dbo].consumer 
after insert
as
BEGIN
	declare @tel varchar(14)
	select @tel = substring(csm_tel, 1, 3) + '-' +  substring(csm_tel, 4, 4) + '-' +  substring(csm_tel, 8, 4) from inserted
	update consumer set csm_tel = @tel
		where csm_ID = (select csm_ID from inserted)	
END
GO

create trigger [dbo].trg_date
on [dbo].consumer 
after insert
as
BEGIN
	declare @date date
	declare @reg_date varchar(10)
	select @reg_date = reg_date from inserted
	select @date = (select convert (date, @reg_date))
	update consumer set reg_date = @date
		where reg_date = (select reg_date from inserted)
	
END
GO


delete from consumer;
insert into consumer values ('beermaster31', '1234', 'Tiffany', 'female', '20121215', '01068374832', 'Ulsan');
insert into consumer values ('stranger', '1234', 'Greg', 'male', '20130205', '01048573423', 'Seoul');
insert into consumer values ('james01', '1234', 'James', 'male', '20160306', '01052355231', 'Seoul');
insert into consumer values ('alcholic', '****', 'Brown', 'male', '20220304', '01014231525', 'Pusan');
insert into consumer values ('iamgroot', '1234', 'Cyle', 'male', '20121115', '01085837683', 'Samcheock');


select * from consumer;
GO






create table cart(
	cart_ID			varchar(10) not null,
	csm_ID			varchar(20) not null,
	beer_ID			varchar(5) not null,
	beer_num		smallint not null,

	primary key (cart_ID),
	foreign key (csm_ID) references consumer(csm_ID) 
		on delete cascade 
		on update cascade,
	foreign key(beer_ID) references beer
		on delete cascade
		on update cascade
	
);

delete from cart;

insert into cart values ('1765890243', 'james01','01423', 3);
insert into cart values ('1765890244', 'alcholic','01487', 5);
insert into cart values ('1765890245', 'alcholic','01573', 3);
insert into cart values ('1765890246', 'alcholic','01573', 7);
insert into cart values ('1765890247', 'beermaster31','02132', 9);
insert into cart values ('1765890248', 'beermaster31','02412', 3);
insert into cart values ('1765890249', 'beermaster31','03415', 4);
insert into cart values ('1765890250', 'iamgroot', '06712', 2);
insert into cart values ('1765890251', 'stranger', '01342', 4);

select * from cart;
GO





create table order_log(
	log_ID		varchar(10) not null,
	csm_ID		varchar(20) not null,
	beer_ID		varchar(5) not null,
	beer_num	smallint not null,

	primary key(log_ID),
	foreign key (csm_ID) references consumer,
	foreign key (beer_ID) references beer
		on delete cascade
		on update cascade
);
GO

create view order_view as
select log_ID, order_log.csm_ID, csm_name, beer_name, beer_num
from order_log
left outer join beer on order_log.beer_ID = beer.beer_ID
left outer join consumer on order_log.csm_ID = consumer.csm_ID
GO


delete from order_log;



insert into order_log values ('0158423152', 'james01','01423', 1);
insert into order_log values ('0158423153', 'beermaster31','01487', 4);
insert into order_log values ('0158423154', 'alcholic','01573', 3);
insert into order_log values ('0158423155', 'beermaster31','01573', 9);
insert into order_log values ('0158423156', 'beermaster31','02132', 6);
insert into order_log values ('0158423157', 'alcholic','02412', 13);
insert into order_log values ('0158423158', 'alcholic','03415', 7);
insert into order_log values ('0158423159', 'iamgroot', '06712', 8);
insert into order_log values ('0158423160', 'stranger', '01342', 6);

select * from order_log;
GO

select * from order_view
select csm_name, count(*) as order_num from order_view group by csm_name
GO

create view beer_info as
select beer.beer_ID, beer_name, beer.dist_name, category.ctg_ID, ctg_name, ABV, price, stock
from beer
left outer join category on beer.ctg_ID = category.ctg_ID
left outer join beer_sell on beer.beer_ID = beer_sell.beer_ID
GO

select * from beer_info
select ctg_name, count(*) from beer_info
	group by ctg_name
GO

create view employee_info as
select employee_ID, employee_name, employee_tel, employee.rank_ID, rank_name, career, wage
from employee
left outer join rank on employee.rank_ID = rank.rank_ID	
GO

create view consumer_info as
select csm_ID, csm_name, csm_sex, reg_date, csm_tel, csm_adress
from consumer
GO

select * from employee_info
GO



create function get_dist_name()
	returns table
	as
	return (
		select distinct dist_name
		from distributor
	);
GO

create function get_ctg_name()
	returns table
	as
	return (
		select ctg_name
		from category
	);
GO

create function get_rank_name()
	returns table
	as
	return (
		select rank_name
		from rank
	);
GO

create procedure add_beer_info
	@beer_ID varchar(5), 
	@beer_name varchar(30), 
	@ctg_ID varchar(3), 
	@ABV decimal(3, 1), 
	@dist_name varchar(20), 
	@price int, 
	@stock int
as
	ALTER TABLE beer NOCHECK constraint  FK__beer__dist_name__300424B4;
	insert into beer values(@beer_ID, @beer_name, @dist_name, @ctg_ID, @ABV, @price)
	ALTER TABLE beer CHECK constraint  FK__beer__dist_name__300424B4;

	ALTER TABLE beer_sell NOCHECK constraint  FK__beer_sell__dist___34C8D9D1;
	insert into beer_sell values(@beer_ID, @dist_name, @stock)
	ALTER TABLE beer_sell CHECK constraint  FK__beer_sell__dist___34C8D9D1;

GO
	
exec add_beer_info '01324', 'Heavy rain helles', '001', 12.3, 'Ganadara Brewery', 3000, 10
GO

create procedure add_employee_info
	@employee_ID	varchar(3),
	@employee_name	varchar(20),
	@employee_tel	varchar(14),
	@career			tinyint,
	@rank_ID		varchar(2)
as
	declare @rank_name		varchar(17)
	declare @wage			dollar
	
	set @rank_name = (select rank_name from rank where @rank_ID = rank_ID)
	set @wage = (select wage from rank where @rank_ID = rank_ID)


	ALTER TABLE employee NOCHECK constraint  FK__employee__rank_I__3C69FB99;
	insert into employee values(@employee_ID, @employee_name, @employee_tel, @career, @rank_ID)
	ALTER TABLE employee CHECK constraint  FK__employee__rank_I__3C69FB99;

GO

exec add_employee_info '132', 'son', '01023291023', 1, '01'
GO
	

select * from get_dist_name()
select * from get_ctg_name()
select * from get_rank_name()

select * from beer_info
select * from employee_info
