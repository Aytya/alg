CREATE FUNCTION one(value integer)
    returns integer as  $$
    BEGIN return value + 1;
    END; $$
    language plpgsql;

select one(20);

CREATE FUNCTION sum(a numeric ,b numeric)
   returns numeric as $$
   BEGIN return a + b ;
   END;$$
   language plpgsql;

select sum(2,3);
--c--
CREATE FUNCTION div_it(a int)
        RETURNS bool AS $$
        BEGIN
            return a%2=0;
        END;
        $$
language PLPGSQL;

select div_it(2);
select div_it(3);
--d--1 variant--
CREATE FUNCTION check_it(password integer) returns varchar as $$
     begin if( password is not null) then return 'valid';
     else return 'invalid';
     end if;
     end ;$$
language plpgsql;

select check_it(1111);
select check_it(null);
--d-- 2 variant --
CREATE FUNCTION password(s text)
        RETURNS bool AS $$
        BEGIN
            return (char_length(s)>=8) and ((strpos(s,'!')>0) or (strpos(s,'@')>0) or (strpos(s,'#')>0) or (strpos(s,'$')>0) or (strpos(s,'%')>0));
        END;
        $$
LANGUAGE plpgsql;
    select password('givemeagoodmark!');
    select password('fail');
--e-- 1 variant --
drop function double_it(VARIADIC list NUMERIC[], OUT total numeric, OUT average numeric);
CREATE OR REPLACE FUNCTION double_it(VARIADIC list NUMERIC[], OUT total numeric, OUT average numeric) as $$
    BEGIN
       SELECT INTO total SUM(list[i])
        FROM generate_subscripts(list, 1) g(i);

       SELECT INTO average avg(list[i])
        FROM generate_subscripts(list, 1) g(i);
    END;$$
    language plpgsql;

select * FROM double_it(4);
--e-- 2 variant
CREATE FUNCTION outs(str TEXT,OUT len int, OUT symbol boolean)
        AS $$
        BEGIN
            len:=char_length(str);
            symbol = (strpos(str,'!')>0) or (strpos(str,'@')>0) or (strpos(str,'#')>0) or (strpos(str,'$')>0) or (strpos(str,'%')>0);
        end;$$
language plpgsql;
        select outs('qr#');



--2--trigger--

--a.Return timestamp of the action within the database.--
    CREATE TABLE table_time(
        id int, string text
    );
    CREATE TABLE out(
        id int generated always as identity , time timestamp(6)
    );
    CREATE FUNCTION times()
        RETURNS TRIGGER AS $$
        BEGIN
            insert into out(time) VALUES (now());
            return new;
        end;$$
language plpgsql;
    CREATE TRIGGER changes
        BEFORE INSERT
        ON table_time
        FOR EACH STATEMENT
        EXECUTE PROCEDURE times();
SELECT * FROM out;
INSERT INTO table_time(string) VALUES ('HTGFKUTFKU');

--b.Computes the age of a person when persons’ date of birth is inserted.--
    CREATE TABLE t2 (id int generated always as identity , birthdate timestamp);
    CREATE TABLE out2( id int generated always as identity,  years int);
    CREATE FUNCTION getage()
        RETURNS TRIGGER
        AS $$
        BEGIN
            INSERT INTO out2(years) VALUES (extract(year from now())-extract(year from new.birthdate));
            return new;
        end;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER yearst
        BEFORE INSERT
        ON t2
        FOR EACH ROW
        EXECUTE PROCEDURE getage();
    SELECT * FROM out2;
    INSERT INTO t2(birthdate) VALUES (now());


--c.Adds 12% tax on the price of the inserted item.---
    CREATE TABLE t3 (id int generated always as identity , price int);
    CREATE TABLE out3( id int generated always as identity,  price int);
    CREATE FUNCTION increase()
        RETURNS TRIGGER
        AS $$
        BEGIN
            new.price:=new.price*1.12;
            return new;
        end;
    $$ LANGUAGE plpgsql;
drop  function increase();
    CREATE TRIGGER incprice
        BEFORE INSERT
        ON t3
        FOR EACH ROW
        EXECUTE PROCEDURE increase();
drop trigger incprice on t3;
    SELECT * FROM t3;
    INSERT INTO t3(price) VALUES (100);

--d.Prevents deletion of any row from only one table.--
    CREATE FUNCTION dont()
        RETURNS TRIGGER
        AS $$
        BEGIN
            raise exception using message = 'S 167', detail = 'D 167', hint = 'H 167', errcode = 'P3333';

        end;
    $$ LANGUAGE plpgsql;
drop function dont;
    CREATE TRIGGER dontdel
        BEFORE delete
        ON t3
        FOR EACH ROW
        EXECUTE PROCEDURE dont();
    SELECT * FROM t3;
    INSERT INTO t3(price) VALUES (120);
    DELETE FROM t3;

--e.Launches functions  1.d and 1.e.--
       CREATE FUNCTION pass(s text)
        RETURNS bool AS $$
        BEGIN
            RETURN (char_length(s)>=8)and((strpos(s,'!')>0)or(strpos(s,'@')>0)or(strpos(s,'#')>0)or(strpos(s,'$')>0)or(strpos(s,'%')>0));
        END;
        $$ LANGUAGE PLPGSQL;


    CREATE FUNCTION L_S(s TEXT,
        OUT len int, OUT symb boolean)
        AS $$
        BEGIN
            len:=char_length(s);
            symb=(strpos(s,'!')>0)or(strpos(s,'@')>0)or(strpos(s,'#')>0)or(strpos(s,'$')>0)or(strpos(s,'%')>0);

        end;
        $$ LANGUAGE plpgsql;

CREATE FUNCTION doit()
        RETURNS TRIGGER
        AS $$
        BEGIN
            raise notice 'pass=% L_S=%',pass(new.tekst),L_S(new.tekst);
            return new;
        end;
    $$ LANGUAGE plpgsql;
DROP FUNCTION doit;
    CREATE TRIGGER dontdel
        BEFORE insert
        ON t
        FOR EACH ROW
        EXECUTE PROCEDURE doit();
 drop trigger dontdel on t;
    SELECT * FROM out;
INSERT INTO t(tekst) VALUES ('HTGFKUTFKU');




--3--
CREATE TABLE worker (id int primary key ,name varchar(20), date_of_birth date, age int, salary int,experience int , discount int );
insert into worker values (1,'a','1999-12-12',12,5000, 24, 1000);
insert into worker values (4,'b','1999-12-12',10,500000, 1, 2000);
insert into worker values (5,'c','1999-12-12',1,6000, 10, 3000);
insert into worker values (2,'d','1999-12-12',2,50, 5, 4000);
insert into worker values (3,'e','1999-12-12',122,3000, 2, 5000);
insert into worker values (6,'f','1999-12-12',136,1000, 36, 6000);

SELECT * FROM worker;
BEGIN;
    UPDATE worker SET salary=salary*1.1*(experience/2);
    UPDATE worker SET discount=discount*1.01 WHERE experience>5;
end;

BEGIN;
    UPDATE worker SET salary=salary*1.15 WHERE age>=40;
    UPDATE worker SET salary=salary*1.15 WHERE experience>=8;
    UPDATE worker SET discount=discount*1.2 WHERE experience>=8;
end;
CREATE TABLE accounts(
    name varchar(25),
    experience integer,
    balance integer,
    discount integer
);