use normalization1;
drop table if exists Seeking;

create table Seeking (
    seeking_ID int(11) unsigned not null auto_increment,
    seeking varchar(40) not null,
    primary key (seeking_ID)
) as
    select distinct substring_index(seeking, ', ', 1) as Seeking
    from my_contacts
    where seeking is not null
    UNION
    select distinct substring_index(seeking, ', ', -1) as Seeking
    from my_contacts
    where seeking is not null
    order by Seeking;

drop table if exists `Contact+Seeking`;

create table `Contact+Seeking`
(
    Contact_ID int(11) unsigned,
    Seeking_ID int(11) unsigned,
    foreign key (Contact_ID) references my_contacts(UID),
    foreign key (Seeking_ID) references Seeking(seeking_ID)
);

insert into `Contact+Seeking`(Contact_ID, Seeking_ID)
select mc.UID, S.seeking_ID
from my_contacts mc
    inner join Seeking S
        on substring_index(mc.seeking, ', ', 1) = S.Seeking
where mc.seeking is not null
union
select my_contacts.UID, S.seeking_ID
from my_contacts
    inner join Seeking S
        on substring_index(my_contacts.seeking, ', ', -1) = S.Seeking
where my_contacts.seeking is not null
order by UID, Seeking_ID;

select mc.last_name, mc.first_name, CS.Seeking_ID, S.Seeking
from `Contact+Seeking` CS
inner join my_contacts mc on CS.Contact_ID = mc.UID
inner join Seeking S on CS.Seeking_ID = S.seeking_ID


alter table my_contacts
    drop column seeking;