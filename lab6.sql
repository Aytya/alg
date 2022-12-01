create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

SELECT * from dealer cross join client;
SELECT * FROM dealer as d inner join client  as c on d.id = c.dealer_id inner join SELL on c.id = sell.client_id;
SELECT * from dealer inner join client on dealer.location = client.city;
SELECT sell.id ,amount,name, city from sell join client on sell.client_id = client.id where amount>100 and 500>amount;
SELECT distinct d.id, d.name ,d.location,d.charge from dealer as d right outer join client as c on c.dealer_id = d.id order by d.id;
--e--
SELECT Count(d.id) from dealer as d left outer join
    client as c on d.id = c.dealer_id group by d.id,d.name,d.location,d.charge,c.id,c.name having Count(d.id) > 2;

SELECT * from dealer;
SELECT * from client;
SELECT * from sell;

----find the dealers and the clients he service, return client name, city, dealer name,commission.
SELECT c.name,d.name,c.city,d.charge from dealer as d full outer join client as c on d.id = c.dealer_id;
----find client name, client city, dealer, commission those dealers who received a commission from the sell more than 12%
SELECT c.name,c.city,d.id,charge from dealer as d inner join client as c on d.id = c.dealer_id where charge > 0.12;
----make a report with client name, city, sell id, sell date, sell amount, dealer name and commission to find that either any of the existing
--clients haven’t made a purchase(sell) or made one or more purchase(sell) by their dealer or by own.
SELECT c.name,c.city,s.id,s.date,s.amount,d.name,d.charge from client as c inner join dealer as d on d.id = c.dealer_id
inner join sell s on c.id = s.client_id;
----find dealers who either work for one or more clients. The client may have made,either one or more purchases, or purchase amount above 2000 and must have a grade,
--or he may not have made any purchase to the associated dealer. Print client name, client grade, dealer name, sell id, sell amount
SELECT c.name,c.priority,d.name,s.id,s.amount from client as c join dealer as d on d.id = c.dealer_id join
    sell as s on c.id = s.client_id where s.amount > 2000 and c.priority is not null;

--2--
----count the number of unique clients, compute average and total purchase amount of client orders by each date.
create view view1 as select count(distinct c.id), avg(s.amount), sum(s.amount),s.date from client as c inner join sell as s on c.id = s.client_id
                                                                        group by s.date order by s.date;
select * from view1;
----find top 5 dates with the greatest total sell amount
create view view2 as SELECT sum(amount),date from sell group by date order by sum(amount) desc limit 5;
select * from view2;
----count the number of sales, compute average and total amount of all sales of each dealer
create view view3 as SELECT COUNT(d.id),AVG(s.amount),SUM(s.amount),d.name,d.id from sell as s join dealer as d on s.dealer_id = d.id group by d.name,d.id ;
select * from view3;
----compute how much all dealers earned from charge(total sell amount *charge) in each location
create view view4 as SELECT d.id,name,location,charge*sum(s.amount) from dealer as d inner join sell as s on d.id = s.dealer_id group by d.id, name, location, charge;
select * from view4;
----compute number of sales, average and total amount of all sales dealers made in each location
create view view5 as SELECT COUNT(s.dealer_id),AVG(s.amount),SUM(s.amount),d.location from dealer as d join sell as s on d.id = s.dealer_id group by d.location;
select * from view5;
----compute number of sales, average and total amount of expenses in each city clients made.
create view view6 as SELECT COUNT(s.client_id),AVG(s.amount),SUM(s.amount - c.priority),c.city from sell as s join client c on s.client_id = c.id group by c.city;
select * from view6;
----find cities where total expenses more than total amount of sales in locations
create view view7 as SELECT c.city from client as c join sell s on c.id = s.client_id where c.priority > s.amount;
select * from view7;