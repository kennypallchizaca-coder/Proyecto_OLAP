--------------------------------------------------------
-- Archivo creado  - miércoles-diciembre-17-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table PROVEEDORES
--------------------------------------------------------

  CREATE TABLE "USUARIO02"."PROVEEDORES" 
   (	"PROVEEDORID" NUMBER(*,0), 
	"NOMBREPROV" CHAR(50 BYTE), 
	"CONTACTO" CHAR(50 BYTE), 
	"CELUPROV" CHAR(12 BYTE), 
	"FIJOPROV" CHAR(12 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into USUARIO02.PROVEEDORES
SET DEFINE OFF;
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('1','Coca Cola S.A.                                    ','Carlos Silva                                      ','0991112233  ','022334455   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('2','FritoLay Ecuador                                  ','Ana Torres                                        ','0992223344  ','022445566   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('3','Nestlé                                           ','Pedro Pino                                        ','0993334455  ','022556677   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('4','La Holandesa                                      ','Luis Vera                                         ','0994445566  ','022667788   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('5','SuperCarnes                                       ','Javier López                                     ','0995556677  ','022778899   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('6','Frutas Andinas                                    ','María Gómez                                     ','0996667788  ','022889900   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('7','Verde Vida                                        ','Juan Castro                                       ','0997778899  ','022990011   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('8','Higiene Total                                     ','Andrea León                                      ','0998889900  ','023001122   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('9','Panadería El Sol                                 ','Gabriel Ruiz                                      ','0999990011  ','023112233   ');
Insert into USUARIO02.PROVEEDORES (PROVEEDORID,NOMBREPROV,CONTACTO,CELUPROV,FIJOPROV) values ('10','Limpio Hogar                                      ','Elena Paredes                                     ','0980001122  ','023223344   ');
--------------------------------------------------------
--  DDL for Index PROVEEDORES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USUARIO02"."PROVEEDORES_PK" ON "USUARIO02"."PROVEEDORES" ("PROVEEDORID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table PROVEEDORES
--------------------------------------------------------

  ALTER TABLE "USUARIO02"."PROVEEDORES" MODIFY ("PROVEEDORID" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."PROVEEDORES" MODIFY ("NOMBREPROV" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."PROVEEDORES" MODIFY ("CONTACTO" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."PROVEEDORES" ADD CONSTRAINT "PROVEEDORES_PK" PRIMARY KEY ("PROVEEDORID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
