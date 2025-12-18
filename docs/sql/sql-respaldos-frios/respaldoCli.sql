--------------------------------------------------------
-- Archivo creado  - miércoles-diciembre-17-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CLIENTES
--------------------------------------------------------

  CREATE TABLE "USUARIO02"."CLIENTES" 
   (	"CLIENTEID" NUMBER(*,0), 
	"CEDULA_RUC" CHAR(10 BYTE), 
	"NOMBRECLA" CHAR(30 BYTE), 
	"NOMBRECONTACTO" CHAR(50 BYTE), 
	"DIRECCIONCLI" CHAR(50 BYTE), 
	"FAX" CHAR(12 BYTE), 
	"EMAIL" CHAR(50 BYTE), 
	"CELULAR" CHAR(12 BYTE), 
	"FIJO" CHAR(12 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into USUARIO02.CLIENTES
SET DEFINE OFF;
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('1','0102030405','Juan Pérez                   ','Juan Pérez                                       ','Av. América 123                                  ',null,'juanp@mail.com                                    ','0991111111  ','022111111   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('2','0203040506','Ana Gómez                    ','Ana Gómez                                        ','Calle Sucre 456                                   ',null,'ana@mail.com                                      ','0992222222  ','022222222   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('3','0304050607','Luis Torres                   ','Luis Torres                                       ','Av. Quito 789                                     ',null,'luis@mail.com                                     ','0993333333  ','022333333   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('4','0405060708','María León                  ','María León                                      ','Calle Loja 321                                    ',null,'maria@mail.com                                    ','0994444444  ','022444444   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('5','0506070809','Pedro Ruiz                    ','Pedro Ruiz                                        ','Av. Cuenca 654                                    ',null,'pedro@mail.com                                    ','0995555555  ','022555555   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('6','0607080910','Lucía Rojas                  ','Lucía Rojas                                      ','Calle Bolívar 111                                ',null,'lucia@mail.com                                    ','0996666666  ','022666666   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('7','0708091011','Carlos Vera                   ','Carlos Vera                                       ','Av. Colón 222                                    ',null,'carlos@mail.com                                   ','0997777777  ','022777777   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('8','0809101112','Sofía Lara                   ','Sofía Lara                                       ','Av. Ordoñez 333                                  ',null,'sofia@mail.com                                    ','0998888888  ','022888888   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('9','0910111213','Fernando Paz                  ','Fernando Paz                                      ','Calle Manabí 444                                 ',null,'fernando@mail.com                                 ','0999999999  ','022999999   ');
Insert into USUARIO02.CLIENTES (CLIENTEID,CEDULA_RUC,NOMBRECLA,NOMBRECONTACTO,DIRECCIONCLI,FAX,EMAIL,CELULAR,FIJO) values ('10','1011121314','Elena Cruz                    ','Elena Cruz                                        ','Av. Zamora 555                                    ',null,'elena@mail.com                                    ','0980000000  ','023000000   ');
--------------------------------------------------------
--  DDL for Index CLIENTES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USUARIO02"."CLIENTES_PK" ON "USUARIO02"."CLIENTES" ("CLIENTEID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table CLIENTES
--------------------------------------------------------

  ALTER TABLE "USUARIO02"."CLIENTES" MODIFY ("CLIENTEID" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CLIENTES" MODIFY ("CEDULA_RUC" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CLIENTES" MODIFY ("NOMBRECLA" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CLIENTES" MODIFY ("NOMBRECONTACTO" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CLIENTES" MODIFY ("DIRECCIONCLI" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CLIENTES" ADD CONSTRAINT "CLIENTES_PK" PRIMARY KEY ("CLIENTEID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
