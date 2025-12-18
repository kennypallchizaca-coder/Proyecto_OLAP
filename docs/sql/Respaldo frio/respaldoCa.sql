--------------------------------------------------------
-- Archivo creado  - miércoles-diciembre-17-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CATEGORIAS
--------------------------------------------------------

  CREATE TABLE "USUARIO02"."CATEGORIAS" 
   (	"CATEGORIAID" NUMBER(*,0), 
	"NOMBRECAT" CHAR(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into USUARIO02.CATEGORIAS
SET DEFINE OFF;
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('1','BEBIDAS                                           ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('2','SNACKS                                            ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('3','LÁCTEOS                                          ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('4','CARNES                                            ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('5','FRUTAS                                            ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('6','VERDURAS                                          ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('7','CEREALES                                          ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('8','LIMPIEZA                                          ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('9','HIGIENE                                           ');
Insert into USUARIO02.CATEGORIAS (CATEGORIAID,NOMBRECAT) values ('10','PANADERÍA                                        ');
--------------------------------------------------------
--  DDL for Index CATEGORIAS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "USUARIO02"."CATEGORIAS_PK" ON "USUARIO02"."CATEGORIAS" ("CATEGORIAID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table CATEGORIAS
--------------------------------------------------------

  ALTER TABLE "USUARIO02"."CATEGORIAS" MODIFY ("CATEGORIAID" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CATEGORIAS" MODIFY ("NOMBRECAT" NOT NULL ENABLE);
  ALTER TABLE "USUARIO02"."CATEGORIAS" ADD CONSTRAINT "CATEGORIAS_PK" PRIMARY KEY ("CATEGORIAID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
