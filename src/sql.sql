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
# 1
create view  vw_CTPNHAP as
select rID,mCode,drReceiptNum,drPrice,sum(drReceiptNum*drPrice)  'Thành tiền '
from detailsReceipt join materials m on detailsReceipt.mID = m.mID;
select * from vw_CTPNHAP;
# 2
create view  vw_CTPNHAP_VT as
select rID, mCode,mName,drReceiptNum,drPrice,sum(drReceiptNum*drPrice) 'thành tiền'
from detailsReceipt join materials m on detailsReceipt.mID = m.mID;
select * from vw_CTPNHAP_VT;
# 3
create view vw_CTPNHAP_VT_PN as
select r.rID,rReceptDate,o.oID,mCode,mName,drReceiptNum,drPrice,sum(drReceiptNum*drPrice) 'thành tiền'
from detailsreceipt
         join receipt r on r.rID = detailsReceipt.rID join materials m on detailsReceipt.mID = m.mID
         join orders o on o.oID = r.oID;
select * from vw_CTPNHAP_VT_PN;
# 4
create view vw_CTPNHAP_VT_PN_DH as
select r.rID,rReceptDate,o.oID,sCode,mCode,mName,drReceiptNum,drPrice,sum(drReceiptNum*drPrice) 'thành tiền'
from detailsreceipt join materials.receipt r on r.rID = detailsReceipt.rID
                    join orders o on o.oID = r.oID join supplier s on o.sID = s.sID
                    join materials m on detailsReceipt.mID = m.mID;
select * from vw_CTPNHAP_VT_PN_DH;
# 5
create view  vw_CTPNHAP_loc as
select rID,mCode,drReceiptNum,drPrice,sum(drReceiptNum*drPrice)'thành tiền'
from detailsreceipt join materials m on detailsReceipt.mID = m.mID
where detailsReceipt.drReceiptNum >=5;
select  * from vw_CTPNHAP_loc;
# 6
create view vw_CTPNHAP_VT_loc as
select rID,mCode,mName,drReceiptNum,drPrice,sum(drReceiptNum*drPrice)'thành tiền'
from detailsreceipt join materials m on detailsReceipt.mID = m.mID
where mUnit = 'bao';
select * from vw_CTPNHAP_VT_loc;
# 7
create view vw_CTPXUAT as
select bID,mCode,dbBIllNum,dbPrice,sum(dbBIllNum*dbPrice)'thành tiền'
from detailsBill join materials m on detailsBill.mID = m.mID;
select * from vw_CTPXUAT;
# 8
create view vw_CTPXUAT_VT as
select bID,mCode,mName, dbBIllNum,dbPrice from detailsBill
                                                   join materials m on detailsBill.mID = m.mID;
select * from vw_CTPXUAT_VT;
# 9
create view  vw_CTPXUAT_VT_PX as
select b.bID, bCustomerName,m.mCode,m.mName,dbBIllNum,dbPrice from detailsBill
                                                                       join materials.bill b on b.bID = detailsBill.bID
                                                                       join materials m on detailsBill.mID = m.mID;
select * from vw_CTPXUAT_VT_PX;
# Tạo các stored procedure sau
# 1
delimiter //
create procedure totalFinalQuantity(in maCode varchar(20))
begin
select mName,sum((inAvailable + inventory.inTotalIn)- inventory.inTotalOut)'số lượng còn lại cuối cùng là'
from inventory join materials m on inventory.mID = m.mID
where mCode = maCode;
end //
delimiter ;
call totalFinalQuantity('x01');
# 2
delimiter //
create procedure totalMoneyOut(in bCode varchar(20) )
begin
select mName,sum(dbBIllNum*dbPrice) 'tổng tiền xuất'
from detailsBill join materials m on detailsBill.mID = m.mID
where mCode = bCode;
end //
delimiter ;
call totalMoneyOut('s01');
# 3
delimiter //
create procedure TotalOrderByCode(in ocode varchar(20))
begin
select mName,sum(dOrderNumber)'tổng số lượng đặt'
from detailsorder d join materials m on d.mID = m.mID
where mCode = ocode ;
end //
delimiter ;
call TotalOrderByCode('l01');
# 4
delimiter //
create procedure addOrderBill(in id int,orderCode varchar(10),odDate date,sID int)
begin
insert into orders value (oID,oCode,oOrderDate,sID);
end //


call addOrderBill(6,'OD001','2022-12-12',5);