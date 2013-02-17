-- Oracle isolation levels
set transaction isolation level read committed;
set transaction isolation level serializable;

-- commit, sapoint and rollback example
select * from regions;
insert into regions(region_id, region_name) values (5, 'Australia');
select * from regions;
savepoint sp_australia;
insert into regions(region_id, region_name) values (6, 'Antarctica');
select * from regions;
rollback to savepoint sp_australia; -- business is going bad in Antarctica
select * from regions;
commit; -- or rollback
