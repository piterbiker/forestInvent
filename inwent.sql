--BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "EGB_OZKTYPES" (
	"ENUMERATION"	TEXT NOT NULL,
	"DESCRIPTION"	TEXT UNIQUE,
	PRIMARY KEY("ENUMERATION")
);
CREATE TABLE IF NOT EXISTS "EGB_OZUTYPES" (
	"ENUMERATION"	TEXT NOT NULL,
	"DESCRIPTION"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ENUMERATION")
);
CREATE TABLE IF NOT EXISTS "INW_PJ_GATUNKI" (
	"ID"	INTEGER NOT NULL,
	"SKROT"	TEXT UNIQUE,
	"NAZWA_PL"	TEXT NOT NULL,
	"NAZWA_LAC"	TEXT,
	"IGLASTE"	INTEGER NOT NULL DEFAULT 0 CHECK("IGLASTE" IN (0, 1, 2)),
	"GRUPA" TEXT NOT NULL, 
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "INW_PJ_KLASY_GR" (
	"ID"	INTEGER NOT NULL,
	"KLASA"	TEXT NOT NULL UNIQUE,
	"MIN"	INTEGER NOT NULL,
	"MAX"	INTEGER NOT NULL,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "INW_PJ_TYPY_LASU"  (
	"ID" INTEGER NOT NULL, 
	"SKROT" TEXT NOT NULL UNIQUE, 
	"RODZAJ" TEXT NOT NULL CHECK ("RODZAJ" in ('N', 'W', 'G')), 
	"OPIS" TEXT NOT NULL, 
	"ZYZNOSC" INTEGER NOT NULL DEFAULT 1, 
	"WILGOTNOSC" INTEGER NOT NULL DEFAULT 1, 
	"REGIEL" INTEGER NOT NULL DEFAULT 1, 
	PRIMARY KEY("ID" AUTOINCREMENT)	 
   );
CREATE TABLE IF NOT EXISTS "INW_PJ_POMIARY" (
	"ID"	INTEGER NOT NULL,
	"NUMER_DZ"	TEXT NOT NULL UNIQUE,
	"ODDZIAL"	TEXT,
	"LOKALIZACJA"	TEXT NOT NULL,
	"JEDN_REJESTROWA"	TEXT,
	"ADRES_LESNY"	TEXT,
	"OZU"	TEXT NOT NULL DEFAULT 'Ls',
	"OZK"	TEXT,
	"CREATED_BY"	TEXT NOT NULL DEFAULT USER,
	"CREATED_DATE"	DATE NOT NULL DEFAULT SYSDATE,
	"TYP_LASU" TEXT, 
	FOREIGN KEY("OZU") REFERENCES "EGB_OZUTYPES"("ENUMERATION"),
	FOREIGN KEY("OZK") REFERENCES "EGB_OZKTYPES"("ENUMERATION"),
	FOREIGN KEY("TYP_LASU") REFERENCES "INW_PJ_TYPY_LASU"("SKROT"),
	PRIMARY KEY("ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "INW_PJ_DRZEWA" (
	"ID"	INTEGER NOT NULL,
	"POMIAR_ID"	INTEGER NOT NULL,
	"GATUNEK"	TEXT NOT NULL,
	"SREDNICA_130"	INTEGER NOT NULL,
	"SREDNICA_10"	NUMERIC NOT NULL DEFAULT 0,
	"WYSOKOSC"	NUMERIC NOT NULL DEFAULT 0,
	"OBWOD_130"	NUMERIC NOT NULL DEFAULT 0,
	"OBWOD_10"	NUMERIC NOT NULL DEFAULT 0,
	"SHAPE"	TEXT,
	"LOC_X"	REAL NOT NULL,
	"LOC_Y"	REAL NOT NULL,
	"LOC_Z"  NUMERIC DEFAULT 0 NOT NULL, 
	"UWAGI" TEXT, 
	FOREIGN KEY("POMIAR_ID") REFERENCES "INW_PJ_POMIARY"("ID"),
	FOREIGN KEY("GATUNEK") REFERENCES "INW_PJ_GATUNKI"("SKROT"),
	PRIMARY KEY("ID" AUTOINCREMENT)
);
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('1','BMwyżw','W','Bór mieszany wyżynny wilgotny','2','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('2','LMwyżw','W','Las mieszany wyżynny wilgotny','3','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('3','Lwyżw','W','Las wyżynny wilgotny','4','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('4','BGśw','G','Bór górski świeży','2','1','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('5','BMGśw','G','Bór mieszany górski świeży','2','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('6','LMGśw','G','Las mieszany górski świeży','2','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('7','LGśw','G','Las górski świeży','2','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('8','LłG','G','Las łęgowy górski','2','5','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('9','Bs','N','Bór suchy','1','1','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('10','Bśw','N','Bór świeży','1','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('11','Bw','N','Bór wilgotny','1','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('12','Bb','N','Bór bagienny','1','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('13','BMb','N','Bór mieszany bagienny','2','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('14','BMw','N','Bór mieszany wilgotny','2','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('15','BMśw','N','Bór mieszany świeży','2','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('16','LMb','N','Las mieszany bagienny','3','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('17','LMw','N','Las mieszany wilgotny','3','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('18','LMśw','N','Las mieszany świeży','3','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('19','Ol','N','Ols','4','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('20','Lw','N','Las wilgotny','4','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('21','Lśw','N','Las świeży','4','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('23','Lł','N','Las łęgowy','5','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('24','OlJ','N','Ols jesionowy','5','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('25','Lłwyż','W','Las łęgowy wyżynny','5','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('26','BMwyżśw','W','Bór mieszany wyżynny świeży','2','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('27','LMwyżśw','W','Las mieszany wyżynny świeży','3','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('28','Lwyżśw','W','Las wyżynny świeży','4','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('29','OlJwyż','W','Ols jesionowy wyżynny','5','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('30','BGw','G','Bór górski wilgotny','3','1','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('31','BMGw','G','Bór mieszany górski wilgotny','3','2','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('32','LMGw','G','Las mieszany górski wilgotny','3','3','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('33','LGw','G','Las górski wilgotny','3','4','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('34','OlJG','G','Ols jesionowy górski','3','5','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('35','BGb','G','Bór górski bagienny','4','1','1');
INSERT INTO "INW_PJ_TYPY_LASU" ("ID","SKROT","RODZAJ","OPIS","ZYZNOSC","WILGOTNOSC","REGIEL") VALUES ('36','BMGb','G','Bór mieszany górski bagienny','4','2','1');
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('I',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('II',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('III',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('IIIa',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('IIIb',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('IV',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('IVa',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('IVb',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('V',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('VI',NULL);
INSERT INTO "EGB_OZKTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('VIz',NULL);
INSERT INTO "EGB_OZUTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('R','gruntOrny');
INSERT INTO "EGB_OZUTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('L','lakaTrwala');
INSERT INTO "EGB_OZUTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('Ps','pastwiskoTrwale');
INSERT INTO "EGB_OZUTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('Ls','Las');
INSERT INTO "EGB_OZUTYPES" ("ENUMERATION","DESCRIPTION") VALUES ('Lz','gruntZadrzewionyIZakrzewiony');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('1','Św','Świerk pospolity','Picea abies','1','Św');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('2','Jd','Jodła pospolita','Abies alba','1','Jd');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('3','Bk','Buk zwyczajny','Fagus sylvatica','0','Bk');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('4','So','Sosna zwyczajna','Pinus sylvestris','1','So');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('5','Dbb','Dąb bezszypułkowy','Quercus petraea','0','Db');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('6','Dbs','Dąb szypułkowy','Quercus robur','0','Db');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('7','Jw','Klon jawor','Acer pseudoplatanus','0','Jw');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('8','Brz','Brzoza brodawkowata','Betula pendula','0','Brz');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('9','Md','Modrzew europejski','Larix decidua','1','Md');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('10','Gb','Grab pospolity','Carpinus betulus','0','Gb');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('11','Olcz','Olsza czarna','Alnus glutinosa','0','Ol');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('12','Olsz','Olsza szara','Alnus incana','0','Ol');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('13','Tpc','Topola czarna','Populus nigra','0','Tp');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('14','Tpb','Topola biała','Populus alba','0','Tp');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('15','Os','Topola osika','Populus tremula','0','Os');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('16','Lpd','Lipa drobnolistna','Tilia cordata','0','Lp');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('17','Lps','Lipa szerokolistna','Tilia platyphyllos','0','Lp');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('18','Wz','Wiąz pospolity','Ulmus minor','0','Wz');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('19','Kl','Klon zwyczajny','Acer platanoides','0','Kl');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('20','Js','Jesion wyniosły','Fraxinus excelsior','0','Js');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('21','Jrz','Jarząb pospolity','Sorbus aucuparia','0','Jrz');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('22','PI','Pozostałe iglaste',null,'2','PI');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('23','PL','Pozostałe liściaste',null,'2','PL');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('24','Dg','Daglezja zielona','Pseudotsuga menziesii','1','Dg');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('25','Lb','Sosna limba','Pinus cembra','1','Lb');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('26','Dbc','Dąb czerwony','Quercus rubra','0','Db');
INSERT INTO "INW_PJ_GATUNKI" ("ID","SKROT","NAZWA_PL","NAZWA_LAC","IGLASTE","GRUPA") values ('27','Soc','Sosna czarna','Pinus nigra','1','So');
INSERT INTO "INW_PJ_KLASY_GR" ("ID","KLASA","MIN","MAX") VALUES (1,'I',7,15);
INSERT INTO "INW_PJ_KLASY_GR" ("ID","KLASA","MIN","MAX") VALUES (2,'II',16,35);
INSERT INTO "INW_PJ_KLASY_GR" ("ID","KLASA","MIN","MAX") VALUES (3,'III',36,55);
INSERT INTO "INW_PJ_KLASY_GR" ("ID","KLASA","MIN","MAX") VALUES (4,'IV',56,75);
INSERT INTO "INW_PJ_KLASY_GR" ("ID","KLASA","MIN","MAX") VALUES (5,'V',76,95);
CREATE UNIQUE INDEX IF NOT EXISTS "EGB_OZKTYPES_PK" ON "EGB_OZKTYPES" (
	"ENUMERATION"
);
CREATE UNIQUE INDEX IF NOT EXISTS "EGB_OZKTYPES_UK1" ON "EGB_OZKTYPES" (
	"DESCRIPTION"
);
CREATE UNIQUE INDEX IF NOT EXISTS "EGB_OZUTYPES_PK" ON "EGB_OZUTYPES" (
	"ENUMERATION"
);
CREATE UNIQUE INDEX IF NOT EXISTS "EGB_OZUTYPES_UK1" ON "EGB_OZUTYPES" (
	"DESCRIPTION"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_GATUNKI_PK" ON "INW_PJ_GATUNKI" (
	"ID"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_GATUNKI_UK1" ON "INW_PJ_GATUNKI" (
	"SKROT"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_KLASY_GR_PK" ON "INW_PJ_KLASY_GR" (
	"ID"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_KLASY_GR_UK1" ON "INW_PJ_KLASY_GR" (
	"KLASA"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_POMIARY_PK" ON "INW_PJ_POMIARY" (
	"ID"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_POMIARY_UK1" ON "INW_PJ_POMIARY" (
	"NUMER_DZ"
);
CREATE UNIQUE INDEX IF NOT EXISTS "INW_PJ_DRZEWA_PK" ON "INW_PJ_DRZEWA" (
	"ID"
);
CREATE VIEW INW_PJ_POMIARY_DEV_V AS 
  select
 p.NUMER_DZ,
 p.LOKALIZACJA, 
 p.ODDZIAL, 
 p.JEDN_REJESTROWA, 
 p.ADRES_LESNY, 
 p.TYP_LASU,  
 t.OPIS as SIEDLISKO, 
 p.OZU || IFNULL(p.OZK, '') as UZYTEK, 
 o.DESCRIPTION as OZU, 
 d.GATUNEK,
 g.GRUPA, 
 g.NAZWA_PL, 
 g.NAZWA_LAC, 
 g.IGLASTE, 
 d.SREDNICA_130,
 d.SREDNICA_10,
 d.WYSOKOSC, 
 d.OBWOD_130, 
 d.OBWOD_10, 
 d.LOC_Z as WYS_NPM, 
 d.LOC_X || ' ' || d.LOC_Y as wkt, 
 d.UWAGI,  
 p.CREATED_DATE,
 p.CREATED_BY
from
    INW_PJ_DRZEWA d
join INW_PJ_POMIARY p on d.POMIAR_ID = p.ID
join INW_PJ_GATUNKI g on d.GATUNEK = g.SKROT
left outer join EGB_OZUTYPES o on p.OZU = o.ENUMERATION
left outer join INW_PJ_TYPY_LASU t on p.TYP_LASU = t.SKROT;
create view INW_PJ_TYPY_LASU_V as 
SELECT
    REGIEL, 
    RODZAJ,
    SKROT,
    OPIS,
    ZYZNOSC, 	
    WILGOTNOSC
FROM
    INW_PJ_TYPY_LASU
order by REGIEL, RODZAJ, ZYZNOSC, WILGOTNOSC;
COMMIT;