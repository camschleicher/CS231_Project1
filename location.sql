use normalization1;
drop table if exists CityTown;

UPDATE  my_contacts
SET location = 'San Francisco, CA'
WHERE location = 'San Fran, CA';

create table CityTown (
    CityTown_ID int(11) not null auto_increment,
    CityTown varchar(40) not null,
    primary key (CityTown_ID)
) as
    select distinct substring_index(location, ',', 1) as CityTown
    from my_contacts
    where substring_index(location, ',', 1) is not null
    order by substring_index(location, ',', 1);


alter table my_contacts
    add column city_ID int(11);

UPDATE my_contacts
    inner join CityTown
    on CityTown.CityTown = substring_index(my_contacts.location, ',', 1)
    set my_contacts.city_ID = CityTown.CityTown_ID
    where CityTown.CityTown is not null;

drop table if exists State;

create table State (
    State_ID int(11) not null auto_increment,
    State varchar(40) not null,
    primary key (State_ID)
) as
    select distinct substring_index(location, ',', -1) as state
    from my_contacts
    where substring_index(location, ',', -1) is not null
    order by substring_index(location, ',', -1);

alter table my_contacts
    add column state_ID int(11);

UPDATE my_contacts
    inner join State
    on State.State = substring_index(my_contacts.location, ',', -1)
    set my_contacts.state_ID = State.State_ID
    where State.State is not null;


select MC.last_name, MC.first_name, MC.location, MC.city_ID, CT.CityTown, MC.state_ID, s.State
    from CityTown as CT
        inner join my_contacts as  MC
    on CT.CityTown_ID = MC.city_ID
        inner join State s on MC.state_ID = s.State_ID
order by MC.UID;

alter table my_contacts
   drop column location;