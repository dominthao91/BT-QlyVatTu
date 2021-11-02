create database Materials;
use Materials;
create table Materials(
                          mID int auto_increment primary key ,
                          mCode varchar(20),
                          mName varchar(20),
                          mUnit varchar(10),
                          mPrice int
);
create table inventory(
                          inID int auto_increment primary key ,
                          mID int,
                          inAvailable int,
                          inTotalIn int,
                          inTotalOut int,
                          foreign key (mID) references materials(mID)
);
create table Supplier(
                         sID int auto_increment primary key ,
                         sCode varchar(10),
                         sName varchar(20),
                         sAddress varchar(50),
                         sPhoneNumber varchar(15)
);
create table Orders(
                       oID int auto_increment primary key ,
                       oCode varchar(10),
                       oOrderDate date ,
                       sID int,
                       foreign key (sID) references supplier(sID)
);
create table receipt(
                        rID int auto_increment primary key ,
                        rCode varchar(10),
                        rReceptDate date,
                        oID int,
                        foreign key (oID) references orders(oID)
);
create table bill(
                     bID int auto_increment primary key ,
                     bCode varchar(10),
                     bDayOUT date,
                     bCustomerName varchar(20)
);
create table detailsOrder(
                             dID int auto_increment primary key ,
                             oID int,
                             mID int,
                             dOrderNumber int,
                             foreign key (oID) references Orders(oID),
                             foreign key (mID) references  materials (mID)
);
create table detailsReceipt(
                               drID int auto_increment primary key ,
                               rID int,
                               mID int,
                               drReceiptNum int,
                               drPrice int,
                               drNote varchar(50),
                               foreign key (rID) references receipt(rID),
                               foreign key (mID) references materials(mID)

);
create table detailsBill(
                            dbID int auto_increment primary key ,
                            bID int,
                            mID int,
                            dbBIllNum int,
                            dbPrice int,
                            dbNote varchar(50),
                            foreign key (bID) references bill(bID),
                            foreign key (mID)references materials(mID)
);