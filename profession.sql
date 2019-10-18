use normalization1;
drop table if exists profession;

create table profession (
    profession_ID int(11) not null auto_increment,
    profession varchar(25) not null,
    primary key (profession_ID)
) as
    select distinct profession
    from my_contacts
    where profession is not null
    order by profession;

alter table my_contacts
    add column profession_ID int(11);

UPDATE my_contacts
    inner join profession
    on profession.profession = my_contacts.profession
    set my_contacts.profession_ID = profession.profession_ID
    where profession.profession is not null;



alter table my_contacts
  drop column profession;