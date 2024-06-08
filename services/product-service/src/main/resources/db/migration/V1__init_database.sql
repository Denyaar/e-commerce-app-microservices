create table if not exists category
(
    id int not null primary key,
    name varchar(255) not null,
    description varchar(255) not null
);

create table if not exists product
(
    id int not null primary key,
    name varchar(255),
    description varchar(255),
    price numeric(38, 2),
    available_quantity double precision not null,
    category_id int not null,
    foreign key (category_id) references category(id)

);

create  sequence if not exists category_seq increment by 50;
create  sequence if not exists product_seq increment by 50;
