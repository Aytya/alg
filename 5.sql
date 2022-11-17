CREATE TABLE Warehouses(
    code integer,
    location character varying(255),
    capacity integer
);
CREATE TABLE Boxes(
    code character(4),
    contents character varying(255),
    value real,
    warehouses integer
);
INSERT INTO Warehouses(code, location, capacity) VALUES(1, 'Chicago', 3);
INSERT INTO Warehouses(code, location, capacity) VALUES(2, 'Rocks', 4);
INSERT INTO Warehouses(code, location, capacity) VALUES(3, 'New York', 7);
INSERT INTO Warehouses(code, location, capacity) VALUES(4, 'Los Angeles', 2);
INSERT INTO Warehouses(code, location, capacity) VALUES(5, 'San Francisko', 8);

INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('0MN7', 'Rocks', 180, 3);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('4H8P', 'Rocks', 250, 1);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('4RT3', 'Scissors', 190, 4);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('7G3H', 'Rocks', 200, 1);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('8JN6', 'Papers', 75, 1);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('8Y6U', 'Papers', 50, 3);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('9J6F', 'Papers', 175, 2);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('LL08', 'Rocks', 140, 4);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('P0H6', 'Scissors', 125, 1);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('P2T6', 'Scissors', 150, 2);
INSERT INTO Boxes(code, contents, value, warehouses) VALUES ('TUSS', 'Papers', 90, 5);

select * from Warehouses;
select value from Boxes where value > 150;
select distinct on(contents) * from Boxes;
select warehouses ,code from boxes;
select warehouses from Boxes where warehouses > 2;
insert into Warehouses(code,location , capacity) values(6,'New-York',3);
insert into Boxes(code,contents,value,warehouses) values('H5RT','Papers',200,2);
update Boxes set value = 0.85*value where value = (select max(value) from Boxes where value <(select max(value) from boxes));
delete from Boxes where value < 150 ;
delete from Boxes where warehouses = (select code from Warehouses where location = 'New-York');